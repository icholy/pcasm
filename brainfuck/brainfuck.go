package main

import (
	"fmt"
	"log"
	"strings"
)

type Token string

func (t Token) String() string { return string(t) }

const (
	GT      = Token("GT")
	LT      = Token("LT")
	PLUS    = Token("PLUS")
	SUB     = Token("SUB")
	DOT     = Token("DOT")
	OPEN    = Token("OPEN")
	CLOSE   = Token("CLOSE")
	EOF     = Token("EOF")
	INVALID = Token("INVALID")
)

var mapping = map[rune]Token{
	'>': GT,
	'<': LT,
	'+': PLUS,
	'-': SUB,
	'.': DOT,
	'[': OPEN,
	']': CLOSE,
}

func Tokenize(s string) []Token {
	var tokens []Token
	for _, r := range s {
		switch r {
		case ' ', '\n', '\r', '\t':
		default:
			tok, ok := mapping[r]
			if !ok {
				tok = INVALID
			}
			tokens = append(tokens, tok)
		}
	}
	return append(tokens, EOF)
}

type Node interface{ fmt.Stringer }

type Op Token

func (o Op) String() string { return string(o) }

type Loop []Node

func (l Loop) String() string {
	nodes := make([]string, len(l))
	for i, n := range l {
		nodes[i] = n.String()
	}
	return fmt.Sprintf("[%s]", strings.Join(nodes, ", "))
}

type Program []Node

func (p Program) String() string {
	nodes := make([]string, len(p))
	for i, n := range p {
		nodes[i] = n.String()
	}
	return strings.Join(nodes, ", ")
}

func ParseNodes(pos int, tokens []Token) ([]Node, int, error) {
	var nodes []Node
	for pos = pos; pos < len(tokens); pos++ {
		tok := tokens[pos]
		switch tok {
		case INVALID:
			return nil, pos, fmt.Errorf("invalid token: %s", tok)
		case EOF:
			return nodes, pos, nil
		case CLOSE:
			return nodes, pos, nil
		case OPEN:
			lnodes, lpos, err := ParseNodes(pos+1, tokens)
			if err != nil {
				return nil, lpos, err
			}
			if tok := tokens[lpos]; tok != CLOSE {
				return nil, pos, fmt.Errorf("expected %s, got %s", CLOSE, tok)
			}
			pos = lpos
			nodes = append(nodes, Loop(lnodes))
		default:
			nodes = append(nodes, Op(tok))
		}
	}
	return nil, 0, fmt.Errorf("missing %s", EOF)
}

func Parse(tokens []Token) (Program, error) {
	nodes, _, err := ParseNodes(0, tokens)
	return Program(nodes), err
}

type Labels struct {
	count int
}

func (l *Labels) Next() string {
	l.count++
	return fmt.Sprintf("label%d", l.count)
}

var (
	DataLabel        = "Data"
	DataPointerLabel = "DataPointer"
)

func CompileOp(op Op, labels *Labels) (string, error) {
	switch Token(op) {
	case GT:
		return fmt.Sprintf("inc [%s]", DataPointerLabel), nil
	case LT:
		return fmt.Sprintf("dec [%s]", DataPointerLabel), nil
	default:
		return "", fmt.Errorf("unsuported op: %s", op)
	}
}

func CompileNode(node Node, labels *Labels) ([]string, error) {
	var instructions []string
	switch node := node.(type) {
	case Op:
		ins, err := CompileOp(node, labels)
		if err != nil {
			return nil, err
		}
		instructions = append(instructions, ins)
	default:
		return nil, fmt.Errorf("unsuported node: %s", node)
	}
	return instructions, nil
}

func Compile(p Program) ([]string, error) {
	var (
		labels       Labels
		instructions []string
	)
	for _, n := range p {
		ins, err := CompileNode(n, &labels)
		if err != nil {
			return nil, err
		}
		instructions = append(instructions, ins...)
	}
	return instructions, nil
}

func main() {
	input := "><"
	tokens := Tokenize(input)
	program, err := Parse(tokens)
	if err != nil {
		log.Fatal(err)
	}
	instructions, err := Compile(program)
	if err != nil {
		log.Fatal(err)
	}
	for _, ins := range instructions {
		fmt.Println(ins)
	}
}
