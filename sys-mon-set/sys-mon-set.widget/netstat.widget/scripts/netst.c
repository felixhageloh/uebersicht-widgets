/*
 * Print interface statistics in bytes per second
 * 
 * Parameters: 
 * -t #		Time interval to compute, default 2 seconds
 * -i <ifname>	Interface name, defaults to 'en0' 
 * -s		Print raw stats
 * 
 * Output: Two numbers separated by a space. First value is input bytes per
 * second. Second value is output bytes per second
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/sysctl.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <net/if.h>
#include <net/if_var.h>
#include <net/if_dl.h>
#include <net/if_types.h>
#include <net/if_mib.h>
#include <net/route.h>

#include <netinet/in.h>
#include <netinet/in_var.h>
#include <unistd.h>

static u_int64_t opackets = 0;
static u_int64_t ipackets = 0;
static u_int64_t obytes = 0;
static u_int64_t ibytes = 0;
static int	raw_stats = 0;

int
get_stats(char *interface)
{
	int		ret = 0;
	char		name      [32];
	int		mib        [6];
	char           *buf = NULL, *lim, *next;
	size_t		len;
	struct if_msghdr *ifm;
	unsigned int	ifindex = 0;

	if (interface != 0)
		ifindex = if_nametoindex(interface);

	mib[0] = CTL_NET;
	mib[1] = PF_ROUTE;
	mib[2] = 0;
	mib[3] = 0;
	mib[4] = NET_RT_IFLIST2;
	mib[5] = 0;

	if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0)
		return ret;
	if ((buf = malloc(len)) == NULL) {
		printf("malloc failed\n");
		exit(1);
	}
	if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
		if (buf)
			free(buf);
		return ret;
	}
	lim = buf + len;
	for (next = buf; next < lim;) {
		ifm = (struct if_msghdr *)next;
		next += ifm->ifm_msglen;

		if (ifm->ifm_type == RTM_IFINFO2) {
			struct if_msghdr2 *if2m = (struct if_msghdr2 *)ifm;
			struct sockaddr_dl *sdl = (struct sockaddr_dl *)(if2m + 1);

			strncpy(name, sdl->sdl_data, sdl->sdl_nlen);
			name[sdl->sdl_nlen] = 0;
			if (interface != 0 && if2m->ifm_index != ifindex)
				continue;

			/*
			 * Get the interface stats.  These may get overriden
			 * below on a per-interface basis.
			 */
			opackets = if2m->ifm_data.ifi_opackets;
			ipackets = if2m->ifm_data.ifi_ipackets;
			obytes = if2m->ifm_data.ifi_obytes;
			ibytes = if2m->ifm_data.ifi_ibytes;
			if (ret == 0) {
				ret = 1;
				if (raw_stats) {
					printf("%5s %10s %14s ",
					       "Name", "Ipkts", "IBytes");
					printf("%10s %14s\n", "Opkts", "Obytes");
				}
			}
			if (raw_stats) {
				printf("%-5s %10llu ", name, ipackets);
				printf("%14llu ", ibytes);
				printf("%10llu ", opackets);
				printf("%14llu\n", obytes);
			}
		}
	}

	free(buf);

	return ret;
}

void
usage(void)
{
	printf("arguments:\n\t-t #\t\tTime interval to compute, default 2 seconds\n");
	printf("\t-i <ifname>\tInterface name, defaults to 'en0'\n");
	printf("\t-s\t\tPrint raw stats\n");
	exit(1);
}

int
main(int argc, char *argv[])
{
	char           *ifname = "en0";
	int		r;
	int		sleeptime = 2;

	int		bflag     , ch, fd;

	bflag = 0;
	while ((ch = getopt(argc, argv, "st:i:")) != -1) {
		switch (ch) {
		case 't':
			sleeptime = atoi(optarg);
			if (sleeptime < 1) {
				sleeptime = 1;
			}
			break;
		case 'i':
			ifname = optarg;
			break;
		case 's':
			raw_stats = 1;
			break;
		default:
			usage();
		}
	}
	argc -= optind;
	argv += optind;

	r = get_stats(ifname);
	if (r) {
		u_int64_t	ib = ibytes;
		u_int64_t	ob = obytes;
		u_int64_t	diffo, diffi;

		sleep(sleeptime);
		get_stats(ifname);
		diffo = (obytes - ob) / (u_int64_t) sleeptime;
		diffi = (ibytes - ib) / (u_int64_t) sleeptime;
		printf("%llu %llu\n", diffi, diffo);
	} else {
		printf("No interface %s\n", ifname);
	}
}
