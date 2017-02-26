
=begin

  목표 : 유전 알고리즘을 이용하여 3자를 수를 합했을때 25이 될수 있는 것

    유전자 선택 25에 가장 가까운 유전자 3개를 그대로 다음세대에 넘겨준다(3 가지).
    가장 가까운 유전자 3개를 랜덤하게 교배하여 다음세대에 넘겨준다(3 가지).
    교배한 유전자를 일정확률로 돌연변이 시킨다(3가지).
    랜덤한 값을 하나 추가 (1가지).

=end

puts "Hello_world"

successNum = 25

generation = 1
change_num = 50 #돌연변이가 일어날 확률 50%

parent_num = 3 #부모 노드 개수 3개

geneNums = 9 #10 generation
genes = Array.new(geneNums) { Hash.new }
next_genes = Array.new(geneNums) { Hash.new }


def gensSuc_reset( genes, successNum)
  for i in 0..(genes.length-1)
    sum = 0
    genes[i].each { |e|  sum += e}
    genes[i].push( :value => (successNum - sum).abs )
  end
end

def first_genes(geneNums, genes)
  for i in 0..geneNums
    genes[i] = 3.times.map{ Random.rand(11) }
  end
end

def print_All(genes)
  for i in 0..(genes.length-1)
    print genes[i]
    puts
  end
end

def sort_gene(genes)
  return genes.sort_by { |x| x[3][:value] }
end

def do_cross(cross_gene1, cross_gene2)
  temperary_array = Array.new
  if Random.rand(2) == 1
    return temperary_array.push( cross_gene1[0] ).push( cross_gene1[1] ).push( cross_gene2[2] )
  else
    return temperary_array.push( cross_gene1[0] ).push( cross_gene2[1] ).push( cross_gene2[2] )
  end
end

def cross(genes, num)

  cross_gene = Array.new(num) { Hash.new }
  next_genes = Array.new

  for i in 0..(num-1) # 0 1 2
    cross_gene[i] = genes[i]
  end

  next_genes.push(do_cross(cross_gene[0], cross_gene[1]))
  next_genes.push(do_cross(cross_gene[1], cross_gene[2]))
  next_genes.push(do_cross(cross_gene[2], cross_gene[0]))
end

def random_change(num, change_gene)
  next_genes = Array.new(3){ Array.new() }

  for i in 0..(change_gene.length-1)
    for j in 0..(change_gene[i].length-1)

      if Random.rand(100) < num
        next_genes[i].push( Random.rand(11) )
      else
        next_genes[i].push( change_gene[i][j] )
      end

    end
  end

  return next_genes
end

def select_finalnext_gene(genes, next_genes)
  for i in 0..3
    next_genes.push(genes[i])
  end
end

def fin(genes)
  genes.each { |x|
    if x[3][:value] == 0
      p "finish"
      p x
      exit
    end}
end

first_genes(geneNums, genes)
gensSuc_reset(genes, successNum)

genes = sort_gene(genes)

puts "generation : #{generation}"
print_All(genes)
fin(genes)
puts "-------------------------"
while true
  generation+=1
  next_genes = cross(genes, parent_num)

  next_genes.concat random_change(change_num,next_genes)
  gensSuc_reset(next_genes, successNum)

  select_finalnext_gene(genes, next_genes)
  next_genes = sort_gene(next_genes)


  puts "generation : #{generation}"
  print_All(next_genes)
  puts "-------------------------"

  fin(next_genes)

  genes = next_genes
end
