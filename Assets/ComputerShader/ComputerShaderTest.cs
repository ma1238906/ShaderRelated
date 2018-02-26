using UnityEngine;

public class ComputerShaderTest : MonoBehaviour
{
    
    public ComputeShader cshader;
    private ComputeBuffer inputBuffer;
    private ComputeBuffer outputBuffer;

    int[] input = new int[5];
    float [] output = new float[5];

    void Start()
    {
        for (int i = 0; i < input.Length; i++)
        {
            input[i] = i;
        }

        int kernel = cshader.FindKernel("CSMain");
        inputBuffer = new ComputeBuffer(input.Length,4);
        outputBuffer = new ComputeBuffer(output.Length,4);
        inputBuffer.SetData(input);
        cshader.SetBuffer(kernel,"input", inputBuffer);
        cshader.SetBuffer(kernel,"output",outputBuffer);
        
        cshader.Dispatch(kernel,1,1,1);
        outputBuffer.GetData(output);

        foreach (float f in output)
        {
            print(f);
        }
    }

    void OnDestroy()
    {
        inputBuffer.Release();
        outputBuffer.Release();
    }
}
