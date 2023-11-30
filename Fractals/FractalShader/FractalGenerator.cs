using UnityEngine;

public class FractalGenerator : MonoBehaviour
{
    public Material fractalMaterial;
    public int maxIterations = 100;
    public float zoomSpeed = 0.5f;

    void Start()
    {
        GameObject fractalQuad = GameObject.CreatePrimitive(PrimitiveType.Quad);
        fractalQuad.GetComponent<MeshRenderer>().material = fractalMaterial;
        fractalMaterial.SetInt("_MaxIterations", maxIterations);
    }

    void Update()
    {
        float zoom = Input.GetAxis("Mouse ScrollWheel") * zoomSpeed;
        Camera.main.transform.Translate(Vector3.forward * zoom);
    }
}
