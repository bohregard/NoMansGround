using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Missile : MonoBehaviour
{

    public ParticleSystem explosion;
    public ParticleSystem smoke;

    private Rigidbody rb;
    // Use this for initialization
    void Start()
    {
        Debug.Log("Loading Missile");
        rb = gameObject.GetComponent<Rigidbody>();
    }

    void OnCollisionEnter(Collision col)
    {
         Debug.Log("Colliding");
         Debug.Log(col.gameObject.name);
         rb.isKinematic = true;
         explosion.Play();
         smoke.Stop();
    }
}
