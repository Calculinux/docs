#!/usr/bin/env python3
"""
Generate icon lists from Material for MkDocs theme for linter validation.
"""
import os
import json
import material

# Get the icons directory from the Material theme
icon_base_path = os.path.join(os.path.dirname(material.__file__), 'templates', '.icons')

def get_icon_names(icon_set_path):
    """Extract icon names from SVG files in a directory."""
    icons = []
    for root, dirs, files in os.walk(icon_set_path):
        for file in files:
            if file.endswith('.svg'):
                # Get relative path from icon set directory
                rel_path = os.path.relpath(os.path.join(root, file), icon_set_path)
                # Convert path to icon name (replace / with -, remove .svg)
                icon_name = rel_path.replace('/', '-').replace('.svg', '')
                icons.append(icon_name)
    return sorted(icons)

def main():
    icon_lists = {}
    
    # Generate lists for each icon set
    for icon_set in ['material', 'octicons', 'fontawesome', 'simple']:
        icon_set_path = os.path.join(icon_base_path, icon_set)
        if os.path.exists(icon_set_path):
            icons = get_icon_names(icon_set_path)
            icon_lists[icon_set] = icons
            print(f"{icon_set}: {len(icons)} icons")
    
    # Write to JSON file
    output_path = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'icon-lists.json')
    with open(output_path, 'w') as f:
        json.dump(icon_lists, f, indent=2)
    
    print(f"\nIcon lists written to: {output_path}")

if __name__ == '__main__':
    main()
