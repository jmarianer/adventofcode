import more_itertools

class Prog(list):
    def __setitem__(self, index, value):
        if index >= len(self):
            self.extend([0]*(index + 1 - len(self)))
        list.__setitem__(self, index, value)

    def __getitem__(self, index):
        if index >= len(self):
            return 0
        return list.__getitem__(self, index)

    cur = 0
    rel = 0

    def param_mode(self, paramno):
        return self[self.cur] // (10**(paramno+1)) % 10

    def get(self, paramno):
        param = self[self.cur + paramno]
        mode = self.param_mode(paramno)
        if mode == 0:
            return self[param]
        elif mode == 1:
            return param
        elif mode == 2:
            return self[self.rel + param]

    def set(self, paramno, val):
        param = self[self.cur + paramno]
        if self.param_mode(paramno) == 0:
            self[param] = val
        else:
            self[param + self.rel] = val

    def perform_instruction(self):
        jumped = False
        out = None
        param_count = [0, 3, 3, 1, 1, 2, 2, 3, 3, 1]

        op = self[self.cur] % 100
        if op == 1:
            self.set(3, self.get(1) + self.get(2))
        elif op == 2:
            self.set(3, self.get(1) * self.get(2))
        elif op == 3:
            self.set(1, next(self.inpt))
        elif op == 4:
            out = self.get(1)
        elif op == 5:
            if self.get(1) != 0:
                self.cur = self.get(2)
                jumped = True
        elif op == 6:
            if self.get(1) == 0:
                self.cur = self.get(2)
                jumped = True
        elif op == 7:
            self.set(3, 1 if self.get(1) < self.get(2) else 0)
        elif op == 8:
            self.set(3, 1 if self.get(1) == self.get(2) else 0)
        elif op == 9:
            self.rel += self.get(1)

        if not jumped:
            self.cur += param_count[op] + 1

        return out

    def program_done(self):
        return self[self.cur] != 99

    def run(self, inpt=iter([])):
        self.cur = 0
        self.rel = 0
        self.inpt = inpt

        while not program_done():
            out = perform_instruction()
            if out is not None:
                yield out


class AsciiProg(Prog):
    def run(self, inpt=''):
        ascii_out = super().run(ord(c) for c in inpt)
        for line in more_itertools.split_at(ascii_out, lambda x: x == 10):
            if len(line) == 1:
                yield(line[0])
            else:
                yield(''.join(chr(i) for i in line))
