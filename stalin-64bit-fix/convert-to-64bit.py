#!/usr/bin/env python3
"""
Stalin 32-bit to 64-bit Converter
Systematically converts stalin.c from 32-bit to 64-bit architecture
"""

import re
import sys
from pathlib import Path
from datetime import datetime

class Stalin64BitConverter:
    def __init__(self, input_file, output_file, log_file):
        self.input_file = Path(input_file)
        self.output_file = Path(output_file)
        self.log_file = Path(log_file)
        self.changes = []
        self.stats = {
            'struct_tag': 0,
            'pointer_casts': 0,
            'alignment_calcs': 0,
            'region_sizes': 0,
            'vector_lengths': 0,
            'total_lines': 0
        }

    def log_change(self, line_num, phase, old_text, new_text):
        """Log a single change"""
        self.changes.append({
            'line': line_num,
            'phase': phase,
            'old': old_text,
            'new': new_text
        })

    def phase1_fix_struct_tag(self, lines):
        """Phase 1: Fix struct w49 tag field"""
        print("Phase 1: Fixing struct w49 tag field...")
        in_struct_w49 = False

        for i, line in enumerate(lines):
            # Detect struct w49 start
            if re.match(r'^struct w49\s*$', line):
                in_struct_w49 = True
                continue

            # Fix tag field if in struct w49
            if in_struct_w49 and 'unsigned tag;' in line:
                old_line = line
                line = line.replace('unsigned tag;', 'uintptr_t tag;')
                lines[i] = line
                self.log_change(i+1, 'Phase 1', old_line.strip(), line.strip())
                self.stats['struct_tag'] += 1
                print(f"  ✓ Line {i+1}: unsigned tag → uintptr_t tag")
                in_struct_w49 = False

            # Exit struct when we hit closing brace
            if in_struct_w49 and line.strip().startswith('}'):
                in_struct_w49 = False

        return lines

    def phase2_fix_pointer_casts(self, lines):
        """Phase 2: Fix pointer casts from unsigned to uintptr_t"""
        print("Phase 2: Fixing pointer casts (3,052 expected)...")
        pattern = r'\(unsigned\)(t[0-9]+)'

        for i, line in enumerate(lines):
            if '(unsigned)t' in line:
                old_line = line
                line, count = re.subn(pattern, r'(uintptr_t)\1', line)
                if count > 0:
                    lines[i] = line
                    self.log_change(i+1, 'Phase 2', old_line.strip(), line.strip())
                    self.stats['pointer_casts'] += count

        print(f"  ✓ Fixed {self.stats['pointer_casts']} pointer casts")
        return lines

    def phase3_fix_alignment(self, lines):
        """Phase 3: Fix alignment calculations from 4-byte to 8-byte"""
        print("Phase 3: Fixing alignment calculations (295 expected)...")
        # Pattern: ((4-(sizeof(...)%4))&3) → ((8-(sizeof(...)%8))&7)

        for i, line in enumerate(lines):
            if '((4-(sizeof' in line and '%4))&3)' in line:
                old_line = line

                # This is a complex nested pattern, handle carefully
                # Replace 4-byte alignment with 8-byte alignment
                line = line.replace('%4))&3)', '%8))&7)')
                line = line.replace('((4-(sizeof', '((8-(sizeof')

                lines[i] = line
                if old_line != line:
                    self.log_change(i+1, 'Phase 3', old_line.strip(), line.strip())
                    self.stats['alignment_calcs'] += 1

        print(f"  ✓ Fixed {self.stats['alignment_calcs']} alignment calculations")
        return lines

    def phase4_fix_region_sizes(self, lines):
        """Phase 4: Fix region_size variables"""
        print("Phase 4: Fixing region_size variables (106 expected)...")

        for i, line in enumerate(lines):
            if line.startswith('unsigned region_size'):
                old_line = line
                line = line.replace('unsigned region_size', 'size_t region_size')
                lines[i] = line
                self.log_change(i+1, 'Phase 4', old_line.strip(), line.strip())
                self.stats['region_sizes'] += 1

        print(f"  ✓ Fixed {self.stats['region_sizes']} region_size variables")
        return lines

    def phase5_fix_vector_lengths(self, lines):
        """Phase 5: Fix vector length fields"""
        print("Phase 5: Fixing vector length fields (22 expected)...")
        in_vector_struct = False

        for i, line in enumerate(lines):
            # Detect vector structure start
            if 'headed_vector_type' in line and 'struct' in line:
                in_vector_struct = True

            # Fix length field if in vector struct
            if in_vector_struct and re.match(r'\s*unsigned length;\s*$', line):
                old_line = line
                line = line.replace('unsigned length;', 'size_t length;')
                lines[i] = line
                self.log_change(i+1, 'Phase 5', old_line.strip(), line.strip())
                self.stats['vector_lengths'] += 1

            # Exit struct
            if in_vector_struct and line.strip().startswith('};'):
                in_vector_struct = False

        print(f"  ✓ Fixed {self.stats['vector_lengths']} vector length fields")
        return lines

    def convert(self):
        """Main conversion process"""
        print(f"\n{'='*70}")
        print(f"Stalin 32-bit → 64-bit Conversion")
        print(f"{'='*70}")
        print(f"Input:  {self.input_file}")
        print(f"Output: {self.output_file}")
        print(f"Log:    {self.log_file}")
        print(f"{'='*70}\n")

        # Read input file
        print("Reading input file...")
        with open(self.input_file, 'r') as f:
            lines = f.readlines()

        self.stats['total_lines'] = len(lines)
        print(f"  ✓ Read {len(lines):,} lines\n")

        # Apply all phases
        lines = self.phase1_fix_struct_tag(lines)
        print()
        lines = self.phase2_fix_pointer_casts(lines)
        print()
        lines = self.phase3_fix_alignment(lines)
        print()
        lines = self.phase4_fix_region_sizes(lines)
        print()
        lines = self.phase5_fix_vector_lengths(lines)
        print()

        # Write output file
        print("Writing output file...")
        with open(self.output_file, 'w') as f:
            f.writelines(lines)
        print(f"  ✓ Wrote {len(lines):,} lines to {self.output_file}\n")

        # Write change log
        self.write_log()

        # Print summary
        self.print_summary()

    def write_log(self):
        """Write detailed change log"""
        print("Writing change log...")

        with open(self.log_file, 'w') as f:
            f.write(f"# Stalin 32-bit → 64-bit Conversion Log\n\n")
            f.write(f"**Date:** {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
            f.write(f"**Input:** {self.input_file}\n")
            f.write(f"**Output:** {self.output_file}\n\n")

            f.write(f"## Summary\n\n")
            f.write(f"- Total lines: {self.stats['total_lines']:,}\n")
            f.write(f"- Total changes: {len(self.changes):,}\n\n")

            for phase, count in [
                ('struct_tag', 'struct w49 tag field'),
                ('pointer_casts', 'pointer casts'),
                ('alignment_calcs', 'alignment calculations'),
                ('region_sizes', 'region_size variables'),
                ('vector_lengths', 'vector length fields')
            ]:
                f.write(f"- {count}: {self.stats[phase]:,}\n")

            f.write(f"\n## Detailed Changes\n\n")

            current_phase = None
            for change in self.changes[:100]:  # First 100 for brevity
                if change['phase'] != current_phase:
                    current_phase = change['phase']
                    f.write(f"\n### {current_phase}\n\n")

                f.write(f"**Line {change['line']}:**\n")
                f.write(f"```diff\n")
                f.write(f"- {change['old']}\n")
                f.write(f"+ {change['new']}\n")
                f.write(f"```\n\n")

            if len(self.changes) > 100:
                f.write(f"\n... and {len(self.changes) - 100:,} more changes\n")

        print(f"  ✓ Wrote change log to {self.log_file}\n")

    def print_summary(self):
        """Print conversion summary"""
        print(f"{'='*70}")
        print(f"CONVERSION COMPLETE")
        print(f"{'='*70}")
        print(f"Total changes: {len(self.changes):,}")
        print(f"  - struct tag field:       {self.stats['struct_tag']:>6,}")
        print(f"  - Pointer casts:          {self.stats['pointer_casts']:>6,}")
        print(f"  - Alignment calculations: {self.stats['alignment_calcs']:>6,}")
        print(f"  - Region size variables:  {self.stats['region_sizes']:>6,}")
        print(f"  - Vector length fields:   {self.stats['vector_lengths']:>6,}")
        print(f"{'='*70}")
        print(f"\n✅ stalin-64bit.c ready for compilation!")
        print(f"📄 See {self.log_file} for detailed change log\n")

def main():
    if len(sys.argv) < 2:
        input_file = "../stalin.c"
    else:
        input_file = sys.argv[1]

    output_file = "../stalin-64bit.c"
    log_file = "CONVERSION_LOG.md"

    converter = Stalin64BitConverter(input_file, output_file, log_file)
    converter.convert()

    print("Next steps:")
    print("  1. Compile: gcc stalin-64bit.c -o stalin-64bit")
    print("  2. Or Cosmopolitan: cosmocc -o stalin-64bit.com stalin-64bit.c")
    print("  3. Test: ./stalin-64bit --version")

if __name__ == "__main__":
    main()
