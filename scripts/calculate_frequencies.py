import numpy as np
import matplotlib.pyplot as plt

def get_buckets(path_to_data, vdd=1.2):
    data = np.loadtxt(path_to_data, skiprows=1)
    data = data[503:]
    time = data[:,0]
    osc_data = data[:,2:10]
    normalized = osc_data - vdd / 2
    buckets = np.fft.fftfreq(time.shape[0], time[1] - time[0])

    return (time, normalized, buckets)


def print_fundamental_frequencies(path_to_data, vdd=1.2):
    time, normalized, buckets = get_buckets(path_to_data, vdd)
    center_freq = time.shape[0] // 2

    for col in range(8):
        dft = np.fft.fft(normalized[:,col])
        position = np.argmax(np.abs(dft[:center_freq]))
        print(f'{col} {buckets[position]}')


def plot_freq_domain(time, normalized, buckets):
    center_freq = time.shape[0] // 2
    plt.figure(figsize=(10, 6))

    for col in range(8):
        dft = np.fft.fft(normalized[:, col])
        magnitude = np.abs(dft[:center_freq])
        plt.plot(buckets[:center_freq], magnitude, label=f'out{col}')

    plt.xlabel('Frequency (Hz)')
    plt.ylabel('Magnitude')
    plt.title('Frequency Domain of Ring Oscillator Outputs')
    plt.legend()
    plt.grid()
    plt.tight_layout()
    plt.show()

def plot_data(path_to_data, vdd = 1.2):
    data = np.loadtxt(path_to_data, skiprows=1)
    time = data[:, 0]

    for col in range(8):
        plt.plot(time, data[:, col + 1], label=f'out{col}')

    plt.xlabel('Time (ns)')
    plt.ylabel('Voltage (v)')
    plt.title('Voltage (v) vs Time (ns)')
    plt.legend()
    plt.grid()
    plt.tight_layout()
    plt.show()

def save_plot_data(path_to_data, filename, vdd = 1.2):
    data = np.loadtxt(path_to_data, skiprows=1)
    time = data[:, 0]

    for col in range(8):
        plt.plot(time, data[:, col + 1], label=f'out{col}')

    plt.xlabel('Time (ns)')
    plt.ylabel('Voltage (v)')
    plt.title('Voltage (v) vs Time (ns)')
    plt.legend()
    plt.grid()
    plt.tight_layout()
    plt.savefig(filename)


def save_plot_freq_domain(time, normalized, buckets, filename):
    center_freq = time.shape[0] // 2
    plt.figure(figsize=(10, 6))

    for col in range(8):
        dft = np.fft.fft(normalized[:, col])
        magnitude = np.abs(dft[:center_freq])
        plt.plot(buckets[:center_freq], magnitude, label=f'out{col}')

    plt.xlabel('Frequency (Hz)')
    plt.ylabel('Magnitude')
    plt.title('Frequency Domain of Ring Oscillator Outputs')
    plt.legend()
    plt.grid()
    plt.tight_layout()
    plt.savefig(filename)
