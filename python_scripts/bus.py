def main():
    with open("file.txt", "w") as file:
        i = 31
        file.write("assign all_registers = {" + "\n")
        for x in range(32):
            file.write("\t" + "reg" + str(i) + "_out," + "\n")
            i = i-1
        file.write("}")

if __name__ == "__main__":
    main()