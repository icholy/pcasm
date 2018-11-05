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

func Parse(pos int, tokens []Token) ([]Node, int, error) {
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
			lnodes, lpos, err := Parse(pos+1, tokens)
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

func main() {
	input := "[->+<]"
	tokens := Tokenize(input)
	nodes, _, err := Parse(0, tokens)
	if err != nil {
		log.Fatal(err)
	}
	for _, n := range nodes {
		fmt.Println(n)
	}
}
