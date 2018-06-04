#!/usr/bin/env node
const fs = require('fs');

function writeWidgets(widgets) {
  const str = JSON.stringify(widgets);
  const out = fs.createWriteStream('widgets.json');
  out.end(str);
}

function remove(id) {
  const widgets = require('../widgets.json');
  const widget = widgets.widgets.find(w => w.id === id)
  if (!widget) {
    throw new Error(`can't find widget ${id}`);
  }
  widgets.widgets.splice(widgets.widgets.indexOf(widget), 1)
  writeWidgets(widgets);
}

const id = process.argv[2];
try {
  remove(id);
  process.stdout.write(`removed ${id}\n`);
} catch (err) {
  process.stdout.write(err.message + '\n');
}
