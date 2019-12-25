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
    regs = [0] * 8
    stack = []
    trace = False

    def get(self, paramno):
        param = self[self.cur + paramno]
        if param <= 32767:
            return param
        else:
            return self.regs[param - 32768]

    def set(self, paramno, val):
        param = self[self.cur + paramno]
        if param <= 32767:
            raise "foo"
        else:
            self.regs[param - 32768] = val

    def perform_instruction(self):
        jumped = False
        out = None
        param_count = [
                0, 2, 1, 1, 3, 3, 1, 2, 2, 3,  # 0 – 9
                3, 3, 3, 3, 2, 2, 2, 1, 0, 1,  # 10 – 10
                1, 0]                          # 20 – 21


        op = self[self.cur]
        if self.cur == 5491:
            print(self.regs[:2])
        """
        if self.cur in {5489, -1}:
            print(self.regs)
            self.trace = True
        if self.cur in {1458, -1}:
            print(self.regs)
            self.trace = False
        if self.trace:
            print(self.cur)
        """

        if op == 1:
            self.set(1, self.get(2))
        elif op == 2:
            self.stack.append(self.get(1))
        elif op == 3:
            self.set(1, self.stack.pop())
        elif op == 4:
            self.set(1, 1 if self.get(2) == self.get(3) else 0)
        elif op == 5:
            self.set(1, 1 if self.get(2) > self.get(3) else 0)
        elif op == 6:
            self.cur = self.get(1)
            jumped = True
        elif op == 7:
            if self.get(1) != 0:
                self.cur = self.get(2)
                jumped = True
        elif op == 8:
            if self.get(1) == 0:
                self.cur = self.get(2)
                jumped = True
        elif op == 9:
            self.set(1, (self.get(2) + self.get(3)) % 32768)
        elif op == 10:
            self.set(1, (self.get(2) * self.get(3)) % 32768)
        elif op == 11:
            self.set(1, (self.get(2) % self.get(3)))
        elif op == 12:
            self.set(1, (self.get(2) & self.get(3)))
        elif op == 13:
            self.set(1, (self.get(2) | self.get(3)))
        elif op == 14:
            self.set(1, ~self.get(2) & 32767)
        elif op == 15:
            self.set(1, self[self.get(2)])
        elif op == 16:
            self[self.get(1)] = self.get(2)
        elif op == 17:
            self.stack.append(self.cur + param_count[op] + 1)
            self.cur = self.get(1)
            jumped = True
        elif op == 18:
            self.cur = self.stack.pop()
            jumped = True
        elif op == 19:
            out = self.get(1)
        elif op == 20:
            self.set(1, next(self.inpt))
        elif op == 21:
            pass
        else:
            raise "bar"

        if not jumped:
            self.cur += param_count[op] + 1

        return out

    def program_done(self):
        return self[self.cur] == 0

    def run(self, inpt=iter([])):
        self.cur = 0
        self.inpt = inpt

        while not self.program_done():
            out = self.perform_instruction()
            if out is not None:
                yield out


class AsciiProg(Prog):
    def run(self, inpt=''):
        ascii_out = super().run(ord(c) for line in inpt for c in line)
        for line in more_itertools.split_at(ascii_out, lambda x: x == 10):
            if len(line) == 1:
                yield(line[0])
            else:
                yield(''.join(chr(i) for i in line))
