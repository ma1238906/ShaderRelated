using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BlurScript : MonoBehaviour
{
    public Shader BlurBoxShader = null;
    private Material BlurBoxMaterial = null;
    [Range(0f,1f)]
    public float BlurSize = .5f;
    [Range(1,32)]
    public int BlurRadius=1;

    private Material material
    {
        get
        {
            if (BlurBoxMaterial == null)
            {
                BlurBoxMaterial = new Material(BlurBoxShader);
                BlurBoxMaterial.hideFlags = HideFlags.HideAndDontSave;
            }
            return BlurBoxMaterial;
        }
    }

    void Start()
    {
        BlurBoxShader = Shader.Find("Custom/BoxBlur");
        if (!SystemInfo.supportsImageEffects)
        {
            enabled = false;
            return;
        }
        if (!BlurBoxShader || !BlurBoxShader.isSupported)
        {
            enabled = false;
            return;
        }
    }

    public void FourTapCone(RenderTexture source, RenderTexture dest, int iteration)
    {
        float off = BlurSize*iteration + 0.5f;
        Graphics.BlitMultiTap(source,dest,material,new Vector2(-off,-off),new Vector2(-off,off),new Vector2(off,off),new Vector2(off,-off));
    }

    private void DownSample4x(RenderTexture source, RenderTexture dest)
    {
        float off = 1.0f;
        Graphics.BlitMultiTap(source, dest, material, new Vector2(-off, -off), new Vector2(-off, off), new Vector2(off, off), new Vector2(off, -off));
    }

    void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture)
    {
        if (BlurSize != 0 && BlurBoxShader != null)
        {
            int rtW = sourceTexture.width / BlurRadius;
            int rtH = sourceTexture.height / BlurRadius;
            RenderTexture buffer = RenderTexture.GetTemporary(rtW, rtH, 0);

            DownSample4x(sourceTexture, buffer);

            for (int i = 0; i < 2; i++)
            {
                RenderTexture buffer2 = RenderTexture.GetTemporary(rtW, rtH, 0);
                FourTapCone(buffer, buffer2, i);
                RenderTexture.ReleaseTemporary(buffer);
                buffer = buffer2;
            }
            Graphics.Blit(buffer, destTexture);

            RenderTexture.ReleaseTemporary(buffer);
        }
        else
        {
            Graphics.Blit(sourceTexture, destTexture);
        }
    }

    void Update()
    {
        if(Application.isPlaying)
            BlurBoxShader = Shader.Find("Custom/BoxBlur");
    }
    public void OnDisable()
    {
        if (BlurBoxMaterial)
            DestroyImmediate(BlurBoxMaterial);
    }
}
