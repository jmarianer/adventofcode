import sys, itertools

class Stack:
    """
    A stack is described as a multiplier and an adder. Each card c goes to
    position (c+a)*m, where addition and multiplication are both done mod the
    stack length, which is assumed to be prime.
    """
    def __init__(self, stacklen):
        self.stacklen = stacklen
        self.add = 0
        self.mult = 1

    def power(self, a, b):
        """
        Calculate a^b mod stacklen
        """
        ret = 1
        for bit in bin(b)[2:]:
            ret *= ret
            if bit == '1':
                ret *= a
            ret %= self.stacklen
        return ret

    def inv(self, a):
        """
        Calculate the multiplicative inverse of a
        """
        return self.power(a, self.stacklen - 2)

    # The three shuffle operations
    def rev(self):
        self.add += self.inv(self.mult)
        self.add %= self.stacklen
        self.mult *= -1
        self.mult %= self.stacklen

    def cut(self, n):
        self.add -= self.inv(self.mult) * n
        self.add %= self.stacklen

    def increment(self, n):
        self.mult *= n
        self.mult %= self.stacklen

    def pos_by_card(self, n):
        """
        Return the given card's position
        """
        return (n + self.add) * self.mult % self.stacklen

    def card_by_pos(self, n):
        """
        Return the card at a given position (the inverse of pos_by_card)
        """
        return (n * self.inv(self.mult) - self.add) % self.stacklen

    def do_n_times(self, n):
        """
        Repeat the basic operation of this stack n times
        """
        add = 0
        mult = 1
        for bit in bin(n)[2:]:
            add += add * self.inv(mult)
            mult *= mult
            if bit == '1':
                add += self.add * self.inv(mult)
                mult *= self.mult
            add %= self.stacklen
            mult %= self.stacklen
        self.add = add
        self.mult = mult

    def perform_lines(self, lines):
        for line in lines:
            if 'new stack' in line:
                self.rev()
            if 'increment' in line:
                n = int(line[20:])
                self.increment(n)
            if 'cut' in line:
                n = int(line[4:])
                self.cut(n)


lines = sys.stdin.readlines()

# Part I
stack = Stack(10007)
stack.perform_lines(lines)
print(stack.pos_by_card(2019))

# Part II
stack = Stack(119315717514047)
stack.perform_lines(lines)
stack.do_n_times(101741582076661)
print(stack.card_by_pos(2020))
