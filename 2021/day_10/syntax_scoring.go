package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"strings"
)

func corruptLines(line string) string {
	stack := make([]string, 0, 15)
	incorrectClosingCharacter := ""

	chunckClosers := map[string]string{
		"}": "{",
		"]": "[",
		")": "(",
		">": "<",
	}

	for _, r := range line {
		char := string(r)
		if closer, ok := chunckClosers[char]; ok {
			if closer != pop(&stack) {
				incorrectClosingCharacter = char
				return incorrectClosingCharacter
			}
		} else {
			stack = append(stack, char)
			continue
		}
	}
	return incorrectClosingCharacter
}

func pop(stack *[]string) string{
	index := len(*stack) - 1
	last := (*stack)[index]
	*stack = (*stack)[:index]
	return last
}

func score(closer string) int {
	scoring := map[string]int{
		"}": 1197,
		"]": 57,
		")": 3,
		">": 25137,
		"":  0,
	}
	return scoring[closer]
}

func sum(scores []int) int {
	result := 0
	for _, score := range scores {
		result += score
	}
	return result
}

func main() {
	if len(os.Args) <= 1 {
		fmt.Printf("USAGE : %s <target_filename> \n", os.Args[0])
		os.Exit(0)
	}

	fileName := os.Args[1]
	fileBytes, err := ioutil.ReadFile(fileName)

	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	sliceData := strings.Split(string(fileBytes), "\n")

	var scores []int
	for _, c := range sliceData {
		scores = append(scores, score(corruptLines(string(c))))
	}

	totalScore := sum(scores)
	fmt.Println("total syntax error score: ", totalScore) // 364389
}
