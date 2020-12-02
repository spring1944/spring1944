-- Author: Soulkiller
-- License: MIT License
-- See: https://gist.github.com/cassiozen/de0dff87eb7ed599b5d0

--[[
This is a tradiotional Neural Network, that can be trained to progressively
returns more accurate results.

This Neural Network is then incorporated in a Genetic Artificial Neural Network,
which is not considering a traditional training paradigm, but it is selecting
the weights according to a genetic algorithm
]]--

local ACTIVATION_RESPONSE = 1

local NeuralNetwork = {
    transfer = function(x)
        return 1 / (1 + math.exp(-x / ACTIVATION_RESPONSE))
    end
}

function NeuralNetwork.create(nIn, nOut, nLayers, nNeuronsPerLayer, learningRate)
    nIn = nIn or 1
    nOut = nOut or 1
    nLayers = nLayers or 2
    nNeuronsPerLayer = nNeuronsPerLayer or nIn
    learningRate = learningRate or 0.5

    -- Create the network, which is a structure like following:
    -- network[layer][neuron][weight]
    local network = setmetatable({
            learningRate = learningRate
        }, {
            __index = NeuralNetwork
        });

    -- Input layer
    network[1] = {}
    for i = 1, nIn do
        network[1][i] = {}
    end

    -- Hidden layers and output
    for i = 2, nLayers + 2 do
        network[i] = {}

        local neuronsInLayer = nNeuronsPerLayer
        if i == nLayers+2 then
            neuronsInLayer = nOut
        end

        for j = 1, neuronsInLayer do
            network[i][j] = {bias = math.random() * 2 - 1}
            local numNeuronInputs = #(network[i-1])

            for k = 1, numNeuronInputs do
                network[i][j][k] = math.random() * 2 - 1
            end
        end
    end

    return network
end

function NeuralNetwork:predict(data)
    if #data ~= #(self[1]) then
        Spring.Log("GANN", LOG.Error,
                   "Prediction received " .. #data .. " inputs, while ".. #(self[1]) .. " are required")
        return nil
    end

    local outputs = {}

    for i = 1, #self do
        -- i = layer
        for j = 1, #(self[i]) do
            -- j = neuron
            if i == 1 then
                self[i][j].result = data[j]
            else
                self[i][j].result = self[i][j].bias
                for k = 1, #(self[i][j]) do
                    -- k = connection
                    self[i][j].result = self[i][j].result +
                                        (self[i][j][k] * self[i-1][k].result)
                end

                self[i][j].result = NeuralNetwork.transfer(self[i][j].result)
                if i == #self then
                    table.insert(outputs, self[i][j].result)
                end
            end
        end
    end

    return outputs
end

function NeuralNetwork:train(data, outputs)
    if #data ~= #(self[1]) then
        Spring.Log("GANN", "error",
                   "Training received " .. tostring(#data) .. " inputs, while ".. tostring(#(self[1])) .. " are required")
        return nil
    end
    if #outputs ~= #(self[#self]) then
        Spring.Log("GANN", "error",
                   "Training received " .. tostring(#data) .. " target outputs, while ".. tostring(#(self[#self])) .. " are required")
        return nil
    end

    --update the internal inputs and outputs
    self:predict(data)

    -- Propagate the errors backward
    for i = #self,2,-1 do
        -- i = layer. We skip the inputs layer
        local tempResults = {}
        for j = 1,#(self[i]) do
            -- j = Neuron
            if i == #self then
                --special calculations for output layer
                self[i][j].delta = (outputs[j] - self[i][j].result) * self[i][j].result * (1 - self[i][j].result)
            else
                local weightDelta = 0
                for k = 1, #(self[i+1]) do
                    -- k = Neuron in the next (deeper) layer
                    weightDelta = weightDelta + self[i+1][k][j] * self[i+1][k].delta
                end
                self[i][j].delta = self[i][j].result * (1 - self[i][j].result) * weightDelta
            end
        end
    end

    -- Learn, i.e. update the weights
    for i = 2, #self do
        for j = 1, #(self[i]) do
            self[i][j].bias = self[i][j].delta * self.learningRate
            for k = 1, #(self[i][j]) do
                self[i][j][k] = self[i][j][k] + self[i][j].delta * self.learningRate * self[i-1][k].result
            end
        end
    end
end

function NeuralNetwork:serialize()
    --[[

    File specs:

        |INFO| - should be FF BP NN

        |I| - number of inputs

        |O| - number of outputs

        |HL| - number of hidden layers

        |NHL| - number of neurons per hidden layer

        |LR| - learning rate

        |BW| - bias and weight values

    ]]--

    local data = "|INFO|FF BP NN|I|" .. tostring(#(self[1])) ..
                 "|O|" .. tostring(#(self[#(self)])) ..
                 "|HL|" .. tostring(#(self) - 2) ..
                 "|NHL|" .. tostring(#(self[2])) ..
                 "|LR|" .. tostring(self.learningRate) ..
                 "|BW|"
    for i = 2, #self do -- nothing to save for input layer
        for j = 1, #(self[i]) do
            local neuronData = tostring(self[i][j].bias) .. "{"

            for k = 1, #(self[i][j]) do
                neuronData = neuronData .. tostring(self[i][j][k])
                neuronData = neuronData .. ","
            end
            data = data .. neuronData .. "}"
        end
    end
    data = data .. "|END|"

    return data
end

function NeuralNetwork.unserialize(data)
    local dataPos = string.find(data,"|") + 1
    local currentChunk = string.sub(data, dataPos, string.find(data, "|", dataPos) - 1)
    local dataPos = string.find(data, "|", dataPos) + 1
    local nIn, nOut, nLayers, nNeuronsPerLayer, learningRate
    local biasWeights = {}
    local errorExit = false

    while currentChunk ~= "END" and not errorExit do
        if currentChunk == "INFO" then
            currentChunk = string.sub(data, dataPos, string.find(data, "|", dataPos) - 1)
            dataPos = string.find(data, "|", dataPos) + 1
            if currentChunk ~= "FF BP NN" then
                errorExit = true
            end
        elseif currentChunk == "I" then
            currentChunk = string.sub(data, dataPos, string.find(data, "|", dataPos) - 1)
            dataPos = string.find(data, "|", dataPos) + 1
            nIn = tonumber(currentChunk)
        elseif currentChunk == "O" then
            currentChunk = string.sub(data, dataPos, string.find(data, "|", dataPos) - 1)
            dataPos = string.find(data,"|",dataPos) + 1
            nOut = tonumber(currentChunk)
        elseif currentChunk == "HL" then
            currentChunk = string.sub(data, dataPos, string.find(data, "|", dataPos) - 1)
            dataPos = string.find(data, "|", dataPos) + 1
            nLayers = tonumber(currentChunk)
        elseif currentChunk == "NHL" then
            currentChunk = string.sub(data, dataPos, string.find(data, "|", dataPos) - 1)
            dataPos = string.find(data, "|", dataPos) + 1
            nNeuronsPerLayer = tonumber(currentChunk)
        elseif currentChunk == "LR" then
            currentChunk = string.sub(data, dataPos, string.find(data, "|", dataPos) - 1)
            dataPos = string.find(data, "|", dataPos) + 1
            learningRate = tonumber(currentChunk)
        elseif currentChunk == "BW" then
            currentChunk = string.sub(data, dataPos, string.find(data, "|", dataPos) - 1)
            dataPos = string.find(data, "|", dataPos) + 1
            local subPos = 1
            local subChunk

            for i = 1, nLayers + 1 do
                biasWeights[i] = {}
                local neuronsInLayer = nNeuronsPerLayer
                if i == nLayers+1 then
                    neuronsInLayer = nOut
                end

                for j = 1,neuronsInLayer do
                    biasWeights[i][j] = {}
                    biasWeights[i][j].bias = tonumber(string.sub(currentChunk, subPos, string.find(currentChunk, "{", subPos) - 1))
                    subPos = string.find(currentChunk, "{", subPos) + 1
                    subChunk = string.sub(currentChunk, subPos, string.find(currentChunk, ",", subPos) - 1)

                    local maxPos = string.find(currentChunk, "}", subPos)

                    while subPos < maxPos do
                        table.insert(biasWeights[i][j], tonumber(subChunk))
                        subPos = string.find(currentChunk, ",", subPos) + 1

                        if string.find(currentChunk, ",", subPos) ~= nil then
                            subChunk = string.sub(currentChunk, subPos, string.find(currentChunk, ",", subPos) - 1)
                        end
                    end
                    subPos = maxPos + 1
                end
            end
        end

        currentChunk = string.sub(data, dataPos, string.find(data, "|", dataPos) - 1)
        dataPos = string.find(data, "|", dataPos) + 1
    end

    if errorExit then
        Spring.Log("GANN", LOG.Error,
                   "Failed to unserialize Neural Network: " .. currentChunk)
        return nil
    end

    local network = NeuralNetwork.create(nIn, nOut, nLayers, nNeuronsPerLayer, learningRate)
    for i = 2, #network do
        for j = 1,#(network[i]) do
            network[i][j].bias = biasWeights[i-1][j].bias
            for k = 1, #(network[i-1]) do
                network[i][j][k] = biasWeights[i-1][j][k]
            end
        end
    end

    return network
end

return NeuralNetwork
