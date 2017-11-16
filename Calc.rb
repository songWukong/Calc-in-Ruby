expr = ARGV[0]

on_error = <<EOM
Expected expression as a string argument:
Use the format: ruby Calc.rb "<your_expression>"
You can perform only these actions "+", "-", "*", "/"
Braces are supported as ( )
Do not use space!
EOM

if (expr.to_s.size == 0)
	puts on_error
	exit(1)
end	 

class Calc

	public

		def parse_Formula(expr)

			expr = expr.dup
			result = parse_Secondary(expr)

			while (expr.size > 0)

				if (expr[0] == "\n")	
					return result
				end	
					
				expr.slice!(0)
				result += parse_Secondary(expr)

			end
				
			return result	

		end	


	private

		def parse_Secondary(expr)

			exp1 = parse_Primary(expr)

		
			while (expr[0] == "+")
				expr.slice!(0)
				exp2 = parse_Primary(expr)
				exp1 += exp2
			end	

			while (expr[0] == "-")
				expr.slice!(0)
				exp2 = parse_Primary(expr)
				exp1 -= exp2	
			end	

			return exp1		

		end
		
		def parse_Primary(expr)

			num1 = parse_Decision(expr)
			
			while (expr[0] == "*")
					expr.slice!(0)
					num2 = parse_Decision(expr)
					num1 *= num2
			end		

			while (expr[0] == "/")
					expr.slice!(0)
					num2 = parse_Decision(expr)
					num1 /= num2	
			end			

			return num1	

		end	


    	def parse_Decision(expr)

    		if (expr[0] =~ /[[:digit:]]/)
				return parse_Num(expr)

			elsif (expr[0] == "-")
				expr.slice!(0)

				if (expr[0] == "(")
					expr.slice!(0)
					exp = -parse_Secondary(expr)
					expr.slice!(0)
					return exp

				else	
					return -parse_Num(expr)

				end	

			elsif (expr[0] == "(")
				expr.slice!(0)
				exp = parse_Secondary(expr)
				expr.slice!(0)
				return exp	

			elsif (!(expr[0] =~ /[[:digit:]]/))
    			puts "Expected digit, but found " + expr[0]
    			expr.slice!(0)
				return parse_Num(expr)

			end	

    	end


    	def parse_Num(expr)

			num = expr.index(/\D/)
   			num = 0 if num.nil?
    		expr.slice!(0..num-1).to_i
    		
		end

end

calc = Calc.new
result = calc.parse_Formula(expr)
puts result