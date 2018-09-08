using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player : MonoBehaviour
{

    public string joy;
    public ParticleSystem particle;
    private Rigidbody rb;

    // Use this for initialization
    void Start()
    {
        rb = GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void Update()
    {
        // if (Input.GetButtonDown("Down"))
        // {
        //     Debug.Log("Down");
        // }

        var hor = Input.GetAxis(joy + "Horizontal");
        var vert = Input.GetAxis(joy + "Vertical");
        var mX = Input.GetAxis(joy + "Mouse X");
        var mZ = Input.GetAxis(joy + "Mouse Y");
        var rBump = Input.GetButton(joy + "RB");
        var lBump = Input.GetButton(joy + "LB");
        var up = Input.GetButton(joy + "Up");
        var down = Input.GetButton(joy + "Down");
        var lT = Input.GetAxis(joy + "LT");
        var rT = Input.GetAxis(joy + "RT");

        if (hor != 0)
        {
            rb.AddRelativeForce(new Vector3(2 * hor, 0, 0)); //todo translate the force
        }

        if (vert != 0)
        {
            rb.AddRelativeForce(new Vector3(0, 0, 2 * vert));
        }

        if (up)
        {
            rb.AddRelativeForce(new Vector3(0, 2, 0));
        }

        if (down)
        {
            rb.AddRelativeForce(new Vector3(0, -2, 0));
        }

        if (mX != 0)
        {
            transform.Rotate(Vector3.up * mX);
        }

        if (mZ != 0)
        {
            transform.Rotate(Vector3.right * mZ);
        }

        if (rBump)
        {
            transform.Rotate(Vector3.back);
        }

        if (lBump)
        {
            transform.Rotate(Vector3.forward);
        }

        if (rT != 0 && rT != -1)
        {
            Fire();
            particle.Play();
        }
        else
        {
            particle.Pause();
        }

        if (lT != 0 && lT != -1)
        {
        }
    }

    void Fire()
    {
        int layerMask = 1 << 8;

        layerMask = ~layerMask;

        RaycastHit hit;
        if (Physics.Raycast(transform.position, transform.TransformDirection(Vector3.forward), out hit, Mathf.Infinity, layerMask))
        {
            Debug.DrawRay(transform.position, transform.TransformDirection(Vector3.forward) * hit.distance, Color.yellow);
            GameObject detected = hit.collider.gameObject;
            if (hit.collider.gameObject.GetComponent<Health>() != null)
            {
                Health health = hit.collider.gameObject.GetComponent<Health>();
                if (health.HP - 0.3f <= 0)
                {
                    health.HP = 0;
                    Debug.LogError("DEAD");
                }
                else
                {
                    health.HP -= 0.3f;
                }
            }
        }
        else
        {
            Debug.DrawRay(transform.position, transform.TransformDirection(Vector3.forward) * 1000, Color.white);
        }
    }
}
