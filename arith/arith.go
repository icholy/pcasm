package main

import (
	"fmt"
	"strconv"
)

type Node interface {
	String() string
}

type Int int

func (i Int) String() string {
	return strconv.Itoa(int(i))
}

type Op int

func (o Op) String() string {
	switch o {
	case Add:
		return "+"
	case Sub:
		return "-"
	case Mul:
		return "*"
	case Div:
		return "/"
	default:
		return "?"
	}
}

const (
	Add Op = iota
	Sub
	Mul
	Div
)

type Binary struct {
	Op    Op
	Left  Node
	Right Node
}

func (b Binary) String() string {
	return fmt.Sprintf("(%s %s %s)", b.Left, b.Op, b.Right)
}

type Code struct{}

func (Code) Ins(format string, args ...interface{}) {
	fmt.Printf(format+"\n", args...)
}

func Compile(n Node, code *Code) {
	switch n := n.(type) {
	case Int:
		code.Ins("push dword %d", int(n))
	case Binary:
		Compile(n.Left, code)
		Compile(n.Right, code)
		fmt.Printf("; %s\n", n)
		code.Ins("pop ebx")
		code.Ins("pop eax")
		switch n.Op {
		case Add:
			code.Ins("add eax, ebx")
		case Sub:
			code.Ins("sub eax, ebx")
		case Mul:
			code.Ins("mul eax, ebx")
		case Div:
			code.Ins("div eax, ebx")
		}
		code.Ins("push eax")
	default:
		panic("invalid node")
	}
}

func main() {
	expr := Binary{
		Op:   Add,
		Left: Int(1),
		Right: Binary{
			Op:    Sub,
			Left:  Int(10),
			Right: Int(5),
		},
	}

	var code Code
	Compile(expr, &code)
}
