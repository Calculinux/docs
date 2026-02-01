// Custom rule to validate Material for MkDocs icon references with complete icon lists
const fs = require('fs');
const path = require('path');

// Load the complete icon lists generated from Material theme
const iconListsPath = path.join(__dirname, '..', 'icon-lists.json');
let iconLists = { material: [], octicons: [], fontawesome: [], simple: [] };

if (fs.existsSync(iconListsPath)) {
  iconLists = JSON.parse(fs.readFileSync(iconListsPath, 'utf8'));
}

module.exports = {
  names: ['material-icons-complete', 'material-complete-icon-validation'],
  description: 'Material for MkDocs icon references must use valid icon names from supported icon sets (complete validation)',
  tags: ['material-mkdocs', 'icons'],
  parser: 'markdownit',
  function: function rule(params, onError) {
    const lines = params.lines;

    // Icon patterns to match - more comprehensive than the default linter
    const iconPatterns = [
      { pattern: /:material-([a-zA-Z0-9\-_]+):/, set: 'material', icons: iconLists.material },
      { 
        pattern: /:fontawesome-(?:solid|regular|brands)-([a-zA-Z0-9\-_]+):/, 
        set: 'fontawesome',
        icons: iconLists.fontawesome,
        transform: (match) => {
          // FontAwesome icons are stored as solid/file.svg, regular/file.svg, brands/file.svg
          const type = match[0].match(/:fontawesome-(solid|regular|brands)-/)[1];
          return `${type}-${match[1]}`;
        }
      },
      { pattern: /:octicons-([a-zA-Z0-9\-_]+):/, set: 'octicons', icons: iconLists.octicons },
      { 
        pattern: /:simple-([a-zA-Z0-9\-_]+):/, 
        set: 'simple', 
        icons: iconLists.simple 
      }
    ];

    for (let lineIndex = 0; lineIndex < lines.length; lineIndex++) {
      const line = lines[lineIndex];
      const lineNumber = lineIndex + 1;

      for (const iconConfig of iconPatterns) {
        let match;
        const regex = new RegExp(iconConfig.pattern.source, 'g');

        while ((match = regex.exec(line)) !== null) {
          const rawIconName = match[1];
          const fullMatch = match[0];
          
          // Transform icon name if needed (e.g., for fontawesome)
          const iconName = iconConfig.transform ? iconConfig.transform(match) : rawIconName;

          // Check if icon exists in the known set
          if (!iconConfig.icons.includes(iconName)) {
            onError({
              lineNumber: lineNumber,
              detail: `Unknown ${iconConfig.set} icon "${rawIconName}". Verify the icon name exists in the ${iconConfig.set} icon set. Available icons: ${iconConfig.icons.length}`,
              context: fullMatch
            });
          }
        }
      }
    }
  }
};
