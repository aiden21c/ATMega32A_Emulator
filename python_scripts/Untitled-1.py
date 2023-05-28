import csv
def main():
    elements = []

    with open("InstructionSet.csv") as csvFile:
        reader = csv.reader(csvFile)
        for row in reader:
                for element in row:
                    elements.append(element)

    with open("file.txt", "w") as file:
        for x in range(66):
            file.write("\telse if(instruction_id == 8'b" + decimal_to_binary(x) + ")\t\t\t// " + elements[x] + "\n")
            file.write("\t" + "begin" + "\n\t\t\n")
            
            # file.write("\t\toutReg = reg" + str(x) + ";" + "\n")
            file.write("\t" + "end" + "\n\n")



def decimal_to_binary(decimal):
    if decimal == 0:
        return "00000000"
    binary = ""
    while decimal > 0:
        binary = str(decimal % 2) + binary
        decimal //= 2
    return binary.zfill(8)


if __name__ == "__main__":
    main()