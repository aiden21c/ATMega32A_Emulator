def main():
    with open("file.txt", "w") as file:
        for x in range(32):
            file.write("\t\t\t5'b" + decimal_to_binary(x) + ":" + "\n")
            file.write("\t\t\t\tbegin" + "\n")
            for y in range(32):
                if(y == x):
                    file.write("\t\t\t\t\tO" + str(y) + " = 1'b1;" + "\n")
                else:
                    file.write("\t\t\t\t\tO" + str(y) + " = 1'b0;" + "\n")
            file.write("\t\t\t\t" + "end" + "\n")



def decimal_to_binary(decimal):
    if decimal == 0:
        return "00000"
    binary = ""
    while decimal > 0:
        binary = str(decimal % 2) + binary
        decimal //= 2
    return binary.zfill(5)


if __name__ == "__main__":
    main()