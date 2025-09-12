function minimum(array)
    # initialize the minimum value counter
    min_value = array[1]
    # update minimum values
    for i in 2:length(array)
        if array[i] < min_value
            min_value = array[i]
        end
    end
    # return found minimum
    return min_value
end

array_values = [89, 90, 95, 100, 100, 78, 99, 98, 100, 95]
@show minimum(array_values);

###################################################################################################
using Statistics

# compute class average
function class_average(grades)
  average_grade = mean(grades)
  return average_grade
end
# enter student grade vector
student_grades = [89, 90, 95, 100, 100, 78, 99, 98, 100, 95]
@show class_average(student_grades);

#######################
# function to simulate a passadieci roll: 3 6-sided dice
function passadieci()
    # this rand() call samples 3 values from the vector [1, 6]
    roll = rand(1:6, 3) 
    return roll
end
# set number of trials and initialize outcome vector
n_trials = 1000
outcomes = zeros(Bool, n_trials)
# simulate number of passadieci rolls and count wins
for i = 1:n_trials
    outcomes[i] = (sum(passadieci()) > 11)
end
win_prob = sum(outcomes) / n_trials # compute average number of wins
@show win_prob;


###########################################################
# function to remove mean from a vector
function remove_mean(vect)
    # fucntion to compute the mean
    function compute_mean(vect)
        element_sum = 0 # initialize sum
        # compute mean and return
        for v in vect
            element_sum += v
        end
        return element_sum / length(vect)
    end

    m = compute_mean(vect) # compute mean
    # return demeaned vector
    return vect .-m
end

random_vect = rand(1000)
@show remove_mean(random_vect)

##########################################################
using Plots
A = [0 1 1 1;
    0 0 0 1;
    0 0 0 1;
    0 0 0 0]

names = ["Plant", "Land Treatment", "Chem Treatment", "Pristine Brook"]
# modify this dictionary to add labels
edge_labels = Dict((1, 2) => "", (1,3) => "", (1, 4) => "",(2, 4) => "",(3, 4) => "")
shapes=[:hexagon, :rect, :rect, :hexagon]
xpos = [0, -1.5, -0.25, 1]
ypos = [1, 0, 0, -1]

p = graphplot(A, names=names,edgelabel=edge_labels, markersize=0.15, markershapes=shapes, markercolor=:white, x=xpos, y=ypos)
display(p)


##########################################################
function costs(x1,x2,x3)
    #total cost for both treatment options
    c = (x1^2)/20 + 0.005*x2
    #discharge water requirements for each input 
    d1 = 0.2*x1
    d2 = 0.005*x2^2
    d3 = x3
    #total discharge water requirement 
    d = d1+d2+d3
    return (d, c)
end

x1 = [10,10,20]
x2 = [50,70,70]
x3 = [40, 20, 10]
output = costs.(x1,x2,x3)
d = [out[1] for out in output]
c = [out[2] for out in output]
@show d;
@show c;

using Distributions

d = Dirichlet(3, 1.0)
samples = rand(d, 1000) .* 100
@show samples[:,1];
results = [costs(sample[1], sample[2], sample[3]) for sample in eachcol(samples)]
ds = [result[1] for result in results]
cs = [result[2] for result in results]

discharge_max = 20

using Plots

scatter(ds, cs, xlabel ="Discharge (d)", ylabel = "Cost (c)", title = "Discharge vs. Treatment Cost", label = "Samples", alpha = 0.5, ms = 1) 

vline!([discharge_max], linestyle =:dash, color =:orange, label = "Maximum Legal Discharge Amount")

############################################################
good_indices = [i for (i, d) in enumerate(ds) if d <= discharge_max]
scatter!(ds[good_indices], cs[good_indices], label = "Satisfying Discharge", ms=2)

d_minc, c_minc = costs(0.0,0.0,100.0)
d_mind, c_mind = costs(80, 20, 0.0)

scatter!([d_minc], [c_minc], color =:purple, label="Min cost: c=$(c_minc), d=$(d_minc)", ms=2)
scatter!([d_mind], [c_mind], color =:red, label="Min discharge: c=$(c_mind), d=$(d_mind)", ms=2)
