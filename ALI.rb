class Registers

  @@memory = Array.new(256)
  @@accumulator = 0
  @@additional_register = 0
  @@program_counter = 0
  @@zero_result_bit = 0
  @@overflow_bit = 0
  @@data = Hash.new

end


class Ali < Registers

  def Ali.interpreter(sal_per_line)
    return if sal_per_line == nil
    instruction = sal_per_line.split(' ')
    if instruction.length() == 2
      case instruction[0]
      when "DEC"
        @@memory[@@program_counter] = instruction[1]
        @@data.merge!(instruction[1] => "")

      when "LDA"
        @@accumulator = @@data[instruction[1]].to_i

      when "LDB"
        @@additional_register = @@data[instruction[1]].to_i

      when "LDI"
        @@accumulator = instruction[1].to_i

      when "STR"
        @@data[instruction[1]] = @@accumulator

      when "JMP"
        @@program_counter = instruction[1].to_i
        return

      when "JZS"
        if @@zero_result_bit == 1
          @@program_counter = instruction[1].to_i
          return
        end

      when "JVS"
        if @@overflow_bit == 1
          @@program_counter = instruction[1].to_i
          return
        end

      else
        puts "Incorrect SAL command."
      end


    else
      case instruction[0]
      when "XCH"
        temp = @@accumulator
        @@accumulator = @@additional_register
        @@additional_register = temp

      when "ADD"
        result=@@accumulator+@@additional_register

        if (result < -2147483648 || result > 2147483647)
          @@overflow_bit = 1
        else
          @@overflow_bit == 0
        end

        @@accumulator=@@accumulator+@@additional_register
        if @@accumulator == 0
          @@zero_result_bit = 1
        end

      when "HLT"
        puts "***Reached Halt***"

      else
        puts "Incorrect SAL command."
      end
    end

    @@program_counter += 1

  end


  sals=Dir.glob("*.txt") #############Edited Line############

  puts sals
  puts "Please choose any SAL file above and enter it's name:"
  input = gets.chomp
  if sals.include? input
    path=File.dirname(__FILE__)+"/"+input  #############Edited Line############
    File.open(path,"r") do |sal|
      i=0
      for line in sal.readlines
        @@memory[i] = line.strip
        i+=1
      end
    end

    loop do

      puts "Enter any of these command:
     l : To execute a line of code
     a : To execute all instruction
     q : To quit"

      c = gets.chomp

      if c == "l"
        if @@memory.include?"HLT"
          if @@program_counter == @@memory.index("HLT")+1
            puts "You reached the HLT statement"
          end

        else
          if @@program_counter == @@memory.index(nil)
            puts "You reached the end of instructions"
          end
        end

        Ali.interpreter(@@memory[@@program_counter])
        puts "Accumulator A= #{@@accumulator}"
        puts "Additional register B= #{@@additional_register}"
        puts "Zero result bit = #{@@zero_result_bit}"
        puts "Overflow bit = #{@@overflow_bit}"
        puts "Program counter = #{@@program_counter}"
        puts "Memory =#{@@memory}"
        puts "******"


      elsif c == "a"
        if @@memory.include?"HLT"
          begin
            Ali.interpreter(@@memory[@@program_counter])
          end while (@@program_counter != @@memory.index("HLT")+1)
        else
          begin
            Ali.interpreter(@@memory[@@program_counter])
          end while (@@program_counter != @@memory.index(nil))
        end

        puts "***All the instructions are executed***"
        puts "Accumulator A= #{@@accumulator}"
        puts "Additional register B= #{@@additional_register}"
        puts "Zero result bit = #{@@zero_result_bit}"
        puts "Overflow bit = #{@@overflow_bit}"
        puts "Program counter = #{@@program_counter}"
        puts "Memory =#{@@memory}"
        puts "******"


      elsif c == "q"
        puts "Quitting from command loop"
        break
      else
        puts "Command loop does not recognize  #{c}"

      end

    end

  else
    puts "Please select a correct SAL file"
  end

end
