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
		code.Ins("mov eax, %d", int(n))
	case Binary:
		Compile(n.Right, code)
		code.Ins("push eax")
		Compile(n.Left, code)
		code.Ins("pop ebx")
		switch n.Op {
		case Add:
			code.Ins("add eax, ebx")
		case Sub:
			code.Ins("sub eax, ebx")
		case Mul:
			code.Ins("imul eax, ebx")
		case Div:
			code.Ins("idiv eax, ebx")
		}
	default:
		panic("invalid node")
	}
}

func Eval(n Node) int {
	switch n := n.(type) {
	case Int:
		return int(n)
	case Binary:
		switch n.Op {
		case Add:
			return Eval(n.Left) + Eval(n.Right)
		case Sub:
			return Eval(n.Left) - Eval(n.Right)
		case Mul:
			return Eval(n.Left) * Eval(n.Right)
		case Div:
			return Eval(n.Left) / Eval(n.Right)
		}
	}
	return 0
}

func main() {

	expr := Binary{
		Op: Add,
		Left: Binary{
			Op:    Mul,
			Left:  Int(10),
			Right: Int(23),
		},
		Right: Binary{
			Op:    Sub,
			Left:  Int(2),
			Right: Int(3),
		},
	}

	var code Code
	fmt.Println(";", expr, "=", Eval(expr))
	Compile(expr, &code)
}
