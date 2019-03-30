NB. train a small neural network on the sin() function.
NB. mini-batches are stored in column-major order.

relu_fw =: 0 >. ]
relu_bw =: (0 <: [) * ] NB. inputs f downstream

matmul_fw =: (+/ . *) NB. params f inputs
matmul_bw_params =: ] (+/ . *) (|: @ [) NB. inputs f downstream
matmul_bw_inputs =: (|: @ [) (+/ . *) ] NB. params f downstream

bias_fw =: + NB. params f inputs
bias_bw_params =: +/"1 NB. f downstream
bias_bw_inputs =: ] NB. f downstream

weight_mat =: (0.1&*) @ (_0.5&+) @ ? @ ([ $ 0"_)

w1 =: weight_mat 32 1
b1 =: 32 $ 0
w2 =: weight_mat 32 32
b2 =: 32 $ 0
w3 =: weight_mat 1 32
b3 =: 1 $ 0

forward =: 3 : 0
inputs =: y
out_w1 =: w1 matmul_fw inputs
out_b1 =: b1 bias_fw out_w1
out_r1 =: relu_fw out_b1

out_w2 =: w2 matmul_fw out_r1
out_b2 =: b2 bias_fw out_w2
out_r2 =: relu_fw out_b2

out_w3 =: w3 matmul_fw out_r2
out_b3 =: b3 bias_fw out_w3
out_b3
)

NB. targets forward_loss inputs
forward_loss =: 4 : 0
deltas =: (forward y) - x
(+/ % #) (0.5 * *: deltas)
)

NB. gradient_step stepsize
gradient_step =: 3 : 0
grad1 =. deltas
b3 =: b3 - (bias_bw_params grad1) * y
grad2 =. bias_bw_inputs grad1
grad3 =. w3 matmul_bw_inputs grad2
w3 =: w3 - (out_r2 matmul_bw_params grad2) * y
grad1 =. out_b2 relu_bw grad3

b2 =: b2 - (bias_bw_params grad1) * y
grad2 =. bias_bw_inputs grad1
grad3 =. w2 matmul_bw_inputs grad2
w2 =: w2 - (out_r1 matmul_bw_params grad2) * y
grad1 =. out_b1 relu_bw grad3

b1 =: b1 - (bias_bw_params grad1) * y
grad2 =. bias_bw_inputs grad1
w1 =: w1 - (inputs matmul_bw_params grad2) * y
)

NB. iteration batch_size
iteration =: 3 : 0
inputs =. ((? (1 , y) $ 0) - 0.5) * 10
outputs =. 1 o. inputs
loss =. outputs forward_loss inputs
gradient_step 0.0001
(+/"1 % #) loss
)

NB. e.g. run_train 10000
run_train =: 3 : 0
for. i. y do. iteration 128 end.
echo 'final loss' ; iteration 4096
)

NB. plot_outputs 0
plot_outputs =: 3 : 0
inputs =. ((i. 1 1000) - 500) % 100
outputs =. forward inputs
targets =. 1 o. inputs
plot (outputs , targets)
)
