def main():
    with open("file.txt", "w") as file:
        for x in range(32):
            file.write("wire [4:0] reg" + str(x) + "_out;" + "\n")

if __name__ == "__main__":
    main()