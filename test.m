clear f1 f2
path_to_seg_results = '/Users/ali/Desktop/exp1_seg_gif_with_roi/';

f1 = gifread(path_to_seg_results+"xy000/Masks/stack_xy000_tr_0_mCherry.gif");
f2 = gifread(path_to_seg_results+"xy000/Masks/stack_xy000_tr_1_mCherry.gif");
out = cat(2,f1,f2);
figure
gifwrite(out,'test.gif');

colorbar;