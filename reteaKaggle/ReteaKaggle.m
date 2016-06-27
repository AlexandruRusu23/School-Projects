load('trainData.mat');
load('testData-public.mat');
Xkaggle = testSamples;
X = trainSamples;
T = zeros(1000, 10);
for i = 1:length(trainLabels)
    T(i, trainLabels(i,1)) = 1;
end

T = T.';

rng('default');

hiddenSize1 = 100;
hiddenSize2 = 50;

autoenc1 = newff(X, T, [hiddenSize1 hiddenSize2], {'tansig' 'tansig' 'softmax'}, 'trainscg');

autoenc1.trainParam.epochs = 400;
autoenc1.trainParam.goal = 0.001;

autoenc1.divideParam.trainRatio = 70/100;
autoenc1.divideParam.valRatio = 15/100;
autoenc1.divideParam.testRatio = 15/100;

[res1 output] = train(autoenc1, X, T);

Y = sim(res1, X);

Y = Y.';

max = 0;
indice = 0;

for i = 1:length(Y)
    max = 0;
    indice = 0;
    for j = 1:10
        if(Y(i, j) > max)
            max = Y(i, j);
            indice = j;
        end
    end
    for j = 1:10 
        if j == indice 
            Y(i, j) = 1;
        else
            Y(i, j) = 0;
        end
    end
end

T = T.';

procent = 0;

for i = 1:length(T)
    for j = 1:10
        if T(i, j) == 1
            if Y(i, j) == 1
                procent = procent+1;
            end
        end
    end
end

procent

resultKaggle = sim(res1, Xkaggle);

view(res1);

resultKaggle = resultKaggle.';

max = 0;
indice = 0;

for i = 1:length(resultKaggle)
    max = 0;
    indice = 0;
    for j = 1:10
        if(resultKaggle(i, j) > max)
            max = resultKaggle(i, j);
            indice = j;
        end
    end
    for j = 1:10 
        if j == indice 
            resultKaggle(i, j) = 1;
        else
            resultKaggle(i, j) = 0;
        end
    end
end

testLabels = zeros(5000, 1);

for i = 1:length(resultKaggle)
    for j = 1:10
        if resultKaggle(i, j) == 1
            testLabels(i,1) = j;
        end
    end
end

[fid message] = fopen('rezultat.csv', 'w');
id = 'Id';
prediction = 'Prediction';
fprintf(fid, '%s,', id);
fprintf(fid, '%s\n', prediction);

for i = 1:length(testLabels)
    fprintf(fid, '%d,%d\n',i, testLabels(i,1));
end

fclose(fid);