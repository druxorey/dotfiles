#!/usr/bin/env python3

def calculateSpeedup(a, k):
    if a > 1:
        a /= 100
    return 1 / ((1 - a) + (a / k))


def calculatePerformanceFactor(s, a):
    if a > 1:
        a /= 100
    return a / ((1 / s) - (1 - a))


def calculateParallelizableFraction(s, k):
    return (1 - (1 / s)) / (1 - (1 / k))


def main():
    option: int = 0
    hadPreviousError: bool = False
    errorMessage: str = ""

    print("\n\033[0;35m[========= AMDAHL LAW =========]\033[0m\n")
    print("1. Speedup factor (s)")
    print("2. Performance factor (k)")
    print("3. Percentage of the program that can be parallelized (a)")

    while True:
        try:
            print("\n\033[K", end="")
            option = int(input("\033[0;33mSelect the variable you want to calculate [1, 2, 3]:\033[0m "))
            if option in [1, 2, 3]:
                break
            errorMessage = "\033[1;31m[ERROR]\033[0m Invalid option. Please select 1, 2, or 3.       "
        except KeyboardInterrupt:
            print("\n\033[1;31m[ERROR]\033[0m Keyboard interrupt detected. Exiting...\033[0m")
            return 1
        except ValueError:
            errorMessage = "\033[1;31m[ERROR]\033[0m Invalid input. Please enter a number.           "

        if hadPreviousError:
            print("\033[4F\033[K")
        else:
            hadPreviousError = True
            print("\033[2F\033[K")

        print(errorMessage)

    if option == 1:
        a: float = float(input("\nEnter the percentage of the program that can be parallelized (a): "))
        k: float = float(input("Enter the number of processors (k): "))
        s: float = calculateSpeedup(a, k)
        print(f"\n\033[1;32m[RESULT]\033[0m The speedup factor is {s:.6f}\n")
    elif option == 2:
        s: float = float(input("\nEnter the speedup factor (s): "))
        a: float = float(input("Enter the percentage of the program that can be parallelized (a): "))
        k: float = calculatePerformanceFactor(s, a)
        print(f"\n\033[1;32m[RESULT]\033[0m The performance factor is {k:.6f}\n")
    elif option == 3:
        s: float = float(input("\nEnter the speedup factor (s): "))
        k: float = float(input("Enter the number of processors (k): "))
        a: float = calculateParallelizableFraction(s, k)
        print(f"\n\033[1;32m[RESULT]\033[0m The percentage of the program that can be parallelized is {a:.6f}\n")


if __name__ == "__main__":
    main()
