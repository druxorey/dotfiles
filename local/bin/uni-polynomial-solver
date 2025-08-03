#!/usr/bin/env python3

import argparse
import math

def quadraticSolver(quadraticTerm, linearTerm, constantTerm):
    if quadraticTerm == 0:
        print("\n\033[1;31m[ERROR]\033[0m The coefficient A (quadratic term) cannot be zero.\n\033[0m")
        return 1

    discriminantValue: float = (linearTerm ** 2) - (4 * quadraticTerm * constantTerm)

    if discriminantValue < 0:
        print("\n\033[1;31m[RESULT]\033[0m The given polynomial has no real solution\n\033[0m")
        return 1

    rootValue: float = math.sqrt(discriminantValue)

    finalPositiveValue: float = (-linearTerm + rootValue) / (2 * quadraticTerm)
    finalNegativeValue: float = (-linearTerm - rootValue) / (2 * quadraticTerm)

    print(f"Positive root: \033[0;32m{finalPositiveValue:.5f}\033[0m")
    if rootValue != 0:
        print(f"Negative root: \033[0;32m{finalNegativeValue:.5f}\033[0m")


def main():
    parser = argparse.ArgumentParser(description='Solve a second degree polynomial.')
    parser.add_argument('quadraticTerm', type=float, help='The coefficient A (quadratic term)')
    parser.add_argument('linearTerm', type=float, help='The coefficient B (linear term)')
    parser.add_argument('constantTerm', type=float, help='The coefficient C (constant term)')

    args = parser.parse_args()

    quadraticSolver(args.quadraticTerm, args.linearTerm, args.constantTerm)

    return 0


if __name__ == "__main__":
	main()
