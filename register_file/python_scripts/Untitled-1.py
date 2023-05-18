def main():
    with open("file.txt", "w") as file:
        for x in range(32):
            file.write("5'b" + decimal_to_binary(x) + ":" + "\n")
            file.write("\t" + "begin" + "\n")
            file.write("\t\toutReg = reg" + str(x) + ";" + "\n")
            file.write("\t" + "end" + "\n")



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