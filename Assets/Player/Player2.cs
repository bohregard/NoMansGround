using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player2 : MonoBehaviour
{

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

        var hor = Input.GetAxis("P2 Horizontal");
        var vert = Input.GetAxis("P2 Vertical");
        var mX = Input.GetAxis("P2 Mouse X");
        var mZ = Input.GetAxis("P2 Mouse Y");
        var rBump = Input.GetButton("P2 RB");
        var lBump = Input.GetButton("P2 LB");
        var up = Input.GetButton("P2 Up");
        var down = Input.GetButton("P2 Down");

        if (hor != 0)
        {
            Debug.Log("P2 Horizontal: " + hor);
            rb.AddRelativeForce(new Vector3(2 * hor, 0, 0)); //todo translate the force
        }

        if (vert != 0)
        {
            Debug.Log("P2 Vertical: " + vert);
            rb.AddRelativeForce(new Vector3(0, 0, 2 * vert));
        }

        if (up)
        {
            Debug.Log("P2 Up");
            rb.AddRelativeForce(new Vector3(0, 2, 0));
        }

        if (down)
        {
            Debug.Log("P2 Down");
            rb.AddRelativeForce(new Vector3(0, -2, 0));
        }

        if (mX != 0)
        {
            Debug.Log("P2 mX: " + mX);
            transform.Rotate(Vector3.up * mX);
        }

        if (mZ != 0)
        {
            Debug.Log("P2 mZ: " + mZ);
            transform.Rotate(Vector3.right * mZ);
        }

        if (rBump)
        {
            Debug.Log("P2 rBump: " + rBump);
            transform.Rotate(Vector3.back);
        }

        if (lBump)
        {
            Debug.Log("P2 lBump: " + rBump);
            transform.Rotate(Vector3.forward);
        }
    }
}
