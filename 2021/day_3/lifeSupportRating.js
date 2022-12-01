#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const readline = require('readline');

const oxygenFilter = true
const co2Filter = false

function filter(line, idx, _, column) {
  return line.substr(column, 1) == "1";
}

function processDiagnosticReport(diagnostics, isO2, column=0) {
  let ones = [], zeros = [];
  diagnostics.forEach((row, idx, report) => (filter(row, idx, report, column) ? ones : zeros).push(row));

  const filteredDiagnostics = [ones, zeros];
  filteredDiagnostics.sort(function (a, b) {
    return b.length - a.length;
  });

  const results = isO2 ? filteredDiagnostics[0] : filteredDiagnostics[1];
  if (results.length == 1) {
    return parseInt(results[0], 2);
  }

  return processDiagnosticReport(results, isO2, column += 1);
}

function getLifeSupportRating() {
  const diagnosticsReport = fs.readFileSync(path.join(__dirname, '/input.txt')).toString().split("\n");

  const oxygenGenerator = processDiagnosticReport(diagnosticsReport, oxygenFilter);
  const co2Scrubber = processDiagnosticReport(diagnosticsReport, co2Filter);
  const lifeSupportRating = oxygenGenerator * co2Scrubber;
  console.log(lifeSupportRating);
}

getLifeSupportRating();