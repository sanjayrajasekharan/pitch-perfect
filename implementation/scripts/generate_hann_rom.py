import numpy as np

def generate_hann_window(N):
    # Generate Hann window values
    n = np.arange(N)
    hann_values = 0.5 * (1 - np.cos(2 * np.pi * n / (N - 1)))
    
    # Scale values to 0 to 4095
    scaled_values = hann_values * 4095
    integer_values = scaled_values.astype(int)
    
    return integer_values

def write_to_hex_file(data, filename):
    with open(filename, 'w') as file:
        for value in data:
            # Write hexadecimal value formatted as required
            file.write(f"{value:04X}\n")

# Parameters
N = 4096  # Adjust the number of points in the Hann window as needed

# Generate data
hann_integers = generate_hann_window(N)

# Write to hex file
filename = "hann_window.hex"
write_to_hex_file(hann_integers, filename)

print(f"Hann window values have been written to {filename}.")
