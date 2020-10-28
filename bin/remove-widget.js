#!/usr/bin/env node
const fs = require("fs");

function writeWidgets(widgets) {
  const str = JSON.stringify(widgets);
  const out = fs.createWriteStream("widgets.json");
  out.end(str);
}

function remove(id) {
  const widgets = require("../widgets.json");
  const newWidgets = widgets.widgets.filter((w) => w.id !== id);
  const numRemoved = widgets.widgets.length - newWidgets.length;

  if (numRemoved > 0) {
    widgets.widgets = newWidgets;
    writeWidgets(widgets);
    console.log(`removed ${id}.`);
  } else {
    console.log("widget not found.");
  }
}

const widgetId = process.argv[2];
console.log(`removing ${widgetId} ...`);
remove(widgetId);
