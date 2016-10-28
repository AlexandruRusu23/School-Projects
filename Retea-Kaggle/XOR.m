P = [ 1 1 0 0; 1 0 1 0];
T = [0 1 1 0];

net = newff( [0 1; 0 1], [2 1], {'tansig' 'purelin'}, 'trainlm');

net.trainParam.epochs = 100;
net.trainParam.show = 5;

net = train(net, P, T);

Y = sim(net, P);

Y