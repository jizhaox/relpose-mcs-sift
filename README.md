# README
This package implements relative pose estimation for multi-camera systems [1] and monocular cameras [2] from point correspondences with scale ratio. The solver for monocular cameras is a re-implementation of [2] using the automatic solver generator of Larsson et al [3]. 

Source codes and Matlab mex files with demo code are provided in the package. The core solvers are written by C++. Matlab mex files are compiled using Ubuntu 16.04 + Matlab R2019a. Run `test_solvers_sift.m` in folder "test" to start.


# Reference

[1] Banglei Guan, and Ji Zhao. [**Relative Pose Estimation for Multi-Camera Systems from Point Correspondences with Scale Ratio**](https://dl.acm.org/doi/abs/10.1145/3503161.3547788). ACM Multimedia, 2022.

[2] Stephan Liwicki and Christopher Zach. [**Scale Exploiting Minimal Solvers for Relative Pose with Calibrated Cameras**](http://www.bmva.org/bmvc/2017/papers/paper028/paper028.pdf). British Machine Vision Conference (BMVC), 2017.

[3] Viktor Larsson, Kalle Astrom, and Magnus Oskarsson. [**Efficient Solvers for Minimal Problems by Syzygy-based Reduction**](https://openaccess.thecvf.com/content_cvpr_2017/papers/Larsson_Efficient_Solvers_for_CVPR_2017_paper.pdf). IEEE/CVF Computer Vision and Pattern Recognition Conference (CVPR), 2017.

If you use this package in an academic work, please cite:

```
@inproceedings{guan2022relative,
  title={Relative Pose Estimation for Multi-Camera Systems from Point Correspondences with Scale Ratio},
  author={Guan, Banglei and Zhao, Ji},
  booktitle={ACM Multimedia},
  year={2022},
  pages={5036--5044}
}
```

# solver_gcam_sift

Four minimal solvers for the relative pose estimation of multi-camera systems using three point correspondences with scale ratio. Returns a maximum of 4 solutions, 8 solutions, or 16 solutions.
* **Solvers**:  `solver_gcam_sift_3inter.mexa64`    `solver_gcam_sift_3intra.mexa64`   `solver_gcam_sift_2inter_1intra.mexa64`   `solver_gcam_sift_1inter_2intra.mexa64`  

* **API**: `[qt_sols, R_sols] = solver_gcam_sift(data, match_type);` 


# Run

Compiled files using Ubuntu 16.04 + Matlab R2019a are provided. You can run the package in Matlab.

` test_solvers_sift.m` is the demo which shows how to call the APIs.



