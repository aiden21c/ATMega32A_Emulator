def main():
    with open("file_mux.txt", "w") as file:
        for x in range(32):
            file.write("multi_bit_multiplexer_2way #(8) reg0_in_Mux (.A(reg" + str(x) + "_out), .B(WD), .S(RegWrite & reg" + str(x) + "_sel), .out(reg" + str(x) + "_in));" "\n")
            
if __name__ == "__main__":
    main()