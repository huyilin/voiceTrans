function y=envelope(signal, Fs)
a=hilbert(signal);
y=abs(a);