const fs = require('fs');
const stringify = require('csv').stringify;

const csvOpts = { columns: ['URL', 'Issue'], quotedString: true };

module.exports = function(filepath) {

  if (!filepath) {
    return;
  }

  const outputFile = fs.openSync(filepath, 'a');

  return {

    addViolations(url, violations) {
      const data = violations.map(v => [url, v.help]);
      stringify(data, csvOpts, (err, output) => {
        fs.appendFileSync(outputFile, output, { encoding: 'utf8' });
      });
    },

    close() {
      fs.closeSync(outputFile);
    },

  };

}
