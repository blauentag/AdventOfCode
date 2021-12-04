#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const readline = require('readline');

const halfRecordCount = 500
let binaryCount = [0,0,0,0,0,0,0,0,0,0,0,0];

function getPowerConsumption() {
  const diagnosticReport = fs.readFileSync(path.join(__dirname, '/input.txt')).toString().split("\n");
  for (const line of diagnosticReport) {
    const chars = line.split("").map( str => parseInt(str, 10) );
    chars.forEach(function (binary, index) {
        binaryCount[index] += binary;
      });
  }

  const gammaRate = parseInt(binaryCount.map(function(num) { return (num > halfRecordCount) ? 1 : 0 }).join(""), 2);
  const epsilonRate = parseInt(binaryCount.map(function(num) { return (num < halfRecordCount) ? 1 : 0 }).join(""), 2);
  const powerConsumption = gammaRate * epsilonRate;
  console.log(powerConsumption)
}

getPowerConsumption();
