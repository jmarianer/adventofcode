class Prog(list):
    def __setitem__(self, index, value):
        if index >= len(self):
            self.extend([None]*(index + 1 - len(self)))
        list.__setitem__(self, index, value)

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

    def run(self, inpt=iter([])):
        self.cur = 0
        self.rel = 0

        param_count = [0, 3, 3, 1, 1, 2, 2, 3, 3, 1]

        while self[self.cur] != 99:
            jumped = False
            op = self[self.cur] % 100
            if op == 1:
                self.set(3, self.get(1) + self.get(2))
            elif op == 2:
                self.set(3, self.get(1) * self.get(2))
            elif op == 3:
                self.set(1, next(inpt))
            elif op == 4:
                yield self.get(1)
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
