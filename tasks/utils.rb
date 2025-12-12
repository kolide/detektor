def red(txt)
  color("31", txt)
end

def yellow(txt)
  color("33", txt)
end

def color(c, txt)
  "\e[#{c}m#{txt}\e[0m"
end
