function example_line_array()

% example_line_array()
%
% Creates a number of line array configuration blobs for devices
% with 2 microphones with spacing of 50 mm and 67 mm
% with 4 microphones with spacing of 28 mm and 78 mm

% SPDX-License-Identifier: BSD-3-Clause
%
% Copyright (c) 2020, Intel Corporation. All rights reserved.
%
% Author: Seppo Ingalsuo <seppo.ingalsuo@linux.intel.com>

% Paths
p.tplg_path = '../../topology/m4/tdfb';
p.sofctl_path = '../../ctl/tdfb';
p.data_path = './data';
addpath('../../test/audio/test_utils');

mkdir_check(p.tplg_path);
mkdir_check(p.sofctl_path);

%% 2 mic arrays
for fs = [16e3 48e3]
	for az = [0 10 25 90 -10 -25 -90]
		for d = [50e-3 67e-3];
			close all;
			line2_one_beam(fs, d, az, p);
		end
	end
end

%% 4 mic arrays
for fs = [16e3 48e3]
	for az = [0 10 25 90 -10 -25 -90]
		for d = [28e-3 78e-3];
			line4_one_beam(fs, d, az, p);
		end
	end
end

end

function line2_one_beam(fs, d, az, p);

% Get defaults
bf = bf_defaults();
bf.input_channel_select = [0 1]; % Input two channels
bf.output_channel_mix   = [3 3]; % Mix both filters to channels 0 and 1 (2^ch)
bf.output_stream_mix    = [0 0]; % Mix both filters to stream 0
bf.num_output_channels = 2;      % Two channels
bf.num_output_streams = 1;       % One sink stream
bf.array = 'line';               % Calculate xyz coordinates for line
bf.mic_n = 2;                    % with two microphones

% From parameters
bf.fs = fs;
bf.mic_d = d;
bf.steer_az = az;

% Design
bf = bf_filenames_helper(bf, p.tplg_path, p.sofctl_path, p.data_path);
bf = bf_design(bf);
bf_export(bf);
end

function line4_one_beam(fs, d, az, p);

% Get defaults
bf = bf_defaults();
bf.input_channel_select = [ 0  1  2  3]; % Input four channels
bf.output_channel_mix   = [15 15 15 15]; % Mix filters to channel 2^0, 2^1, 2^2, 2^3
bf.output_stream_mix    = [ 0  0  0  0]; % Mix filters to stream 0
bf.num_output_channels = 4;               % Four channels
bf.num_output_streams = 1;                % One sink stream
bf.array = 'line';                        % Calculate xyz coordinates for line
bf.mic_n = 4;                             % with two microphones

% From parameters
bf.fs = fs;
bf.mic_d = d;
bf.steer_az = az;

% Design
bf = bf_filenames_helper(bf, p.tplg_path, p.sofctl_path, p.data_path);
bf = bf_design(bf);
bf_export(bf);

end
