let getGitAuthor = () => {
  let cp = require('child_process');

  let name = cp.execSync('git config user.name').toString().trim();
  let email = cp.execSync('git config user.email').toString().trim();

  return `${name} <${email}>`;
};

let createFile = (filename, lines) => {
  let fs = require('fs');

  fs.writeFileSync(filename, lines.join('\n'));
};

createFile('.editorconfig', [
  'root = true',
  '',
  '[*]',
  'indent_style = space',
  'indent_size = 2',
  'charset = utf-8',
  'end_of_line = lf',
  'trim_trailing_whitespace = true',
  'insert_final_newline = true',
]);

createFile('.gitignore', [
  'node_modules',
]);

module.exports = {
  name: basename,
  version: '0.0.1',
  description: '',
  keywords: [],
  license: 'MIT',
  author: getGitAuthor(),
  private: true,

  scripts: {
    test: 'echo "TODO: tests"; false'
  },
};
