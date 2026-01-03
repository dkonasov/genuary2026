const SEQUENCE_LENGTH = 50;

const fib = [0, 1];
for (let i = 2; i < SEQUENCE_LENGTH; i++) {
  fib[i] = fib[i - 1] + fib[i - 2];
}

export const fibbonaciUniforms = {
  step: 1 / (fib.at(-1) ?? 1),
  totalSegments: SEQUENCE_LENGTH,
  sequence: fib,
};
