#!/usr/bin/env node
const fs = require('fs');

function writeWidgets(widgets) {
  const str = JSON.stringify(widgets);
  const out = fs.createWriteStream('widgets.json');
  out.end(str);
}

function addWidget(widget) {
  const widgets = require('../widgets.json');
  if (widgets.widgets.find(w => w.id === widget.id)) {
    throw new Error(`widget id is already taken (${widget.id})`);
  }
  widgets.widgets.push(widget);
  writeWidgets(widgets);
}

function reportProgress(progress) {
  console.log(progress);
}

const getWidget = require('../src/getWidget');
getWidget(process.argv[2], reportProgress)
  .then(addWidget)
  .then(() => process.stdout.write('done\n'))
  .catch(err => { console.log(err) });
