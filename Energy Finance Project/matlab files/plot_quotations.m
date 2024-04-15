function fig_handle = plot_quotations(time, quotations, fig, style)

quotations = [quotations quotations]';
time = time';

figure(fig);
fig_handle = plot(time,quotations,style,'Marker','*');

end

