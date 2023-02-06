from bokeh.models import ColumnDataSource, BoxAnnotation, Span
from bokeh.plotting import figure, output_file, save
from Mean_EBinning import Mean_EBinning

# loading sample data
sample_data = []
with open("sample_2465_2524.txt", "r") as sample_file:
    for line in sample_file:
        sample_data.append(float(line))

EBinning = Mean_EBinning(max_window_size=12, ini_binsize=8, alpha=0.95)

# adding instances to Mean-EBinning
for instance in sample_data:
    EBinning.add_element(instance)

# if the buffer is not empty and X_t ends, we will put buffer into window.
EBinning.insert_latest_buffer()

"""Displaying result with BokehJS. 

NOTE
-----
For more detail, visit our supplementary dataset
"""

output_file(filename="result.html")
TOOLTIPS = [
    ("index", "$index"),
    ("(x,y)", "$x, $y"),
]
x_axis_data = [*range(len(sample_data))]
plot = figure(tooltips=TOOLTIPS, title="result", x_axis_label="time", y_axis_label="Flux",
                  sizing_mode='stretch_both')

# Plotting raw data
raw_datasource = ColumnDataSource(data=dict(x=x_axis_data, y=sample_data))
plot.line('x', 'y', source=raw_datasource, line_alpha=0.5, color="black", line_width=2, legend_label="Raw")
plot.circle('x', 'y', source=raw_datasource, color="black", fill_alpha=0.6, legend_label="Raw", size=2)

# Plotting transient pattern
answer_box_annotation = BoxAnnotation(left=2465, right=2524, fill_alpha=0.2, fill_color="#FF5733")
L_span = Span(location=2465,dimension='height', line_color="#C70039", line_dash='4 4', line_width=2)
R_span = Span(location=2524, dimension='height', line_color="#C70039", line_dash='4 4', line_width=2)
plot.add_layout(answer_box_annotation)
plot.add_layout(L_span)
plot.add_layout(R_span)

# Plotting sketching result
sketching_result = []
for bin_list in EBinning.get_window:
    temp = [bin_list.get_mu] * bin_list.get_n
    sketching_result = sketching_result + temp
sketching_datasource = ColumnDataSource(data=dict(x=x_axis_data, y=sketching_result))
plot.line('x', 'y', source=sketching_datasource, color="blue", line_width=4, legend_label="Mean_EBinning")

# setting legend
plot.legend.border_line_width = 3
plot.legend.click_policy = "hide"
plot.legend.border_line_color = "navy"
plot.legend.border_line_alpha = 0.0

save(plot)