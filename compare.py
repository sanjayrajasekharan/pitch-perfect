import sys


def compare_files(file1_path, file2_path, output_file):
    with open(file1_path, 'r') as file1, open(file2_path, 'r') as file2, open(output_file, 'w') as output:
        file1_lines = file1.readlines()
        file2_lines = file2.readlines()

        for line_num, (line1, line2) in enumerate(zip(file1_lines, file2_lines), start=1):
            if line1 != line2:
                output.write(f"Difference at line {line_num}:\n")
                output.write(f"  File 1: {line1.strip()}\n")
                output.write(f"  File 2: {line2.strip()}\n")

        #if len(file1_lines) > len(file2_lines):
            #for line_num in range(len(file2_lines), len(file1_lines)):
                #output.write(f"Extra line in File 1 at line {line_num + 1}: {file1_lines[line_num].strip()}\n")
        #elif len(file1_lines) < len(file2_lines):
            #for line_num in range(len(file1_lines), len(file2_lines)):
                #output.write(f"Extra line in File 2 at line {line_num + 1}: {file2_lines[line_num].strip()}\n")


def main():
    if len(sys.argv) != 4:
        print("Usage: python script.py <file1_path> <file2_path> <output_file>")
        sys.exit(1)

    file1_path = sys.argv[1]
    file2_path = sys.argv[2]
    output_file = sys.argv[3]
    compare_files(file1_path, file2_path, output_file)


if __name__ == "__main__":
    main()
