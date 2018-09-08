using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player1 : MonoBehaviour
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

        var hor = Input.GetAxis("P1 Horizontal");
        var vert = Input.GetAxis("P1 Vertical");
        var mX = Input.GetAxis("P1 Mouse X");
        var mZ = Input.GetAxis("P1 Mouse Y");
        var rBump = Input.GetButton("P1 RB");
        var lBump = Input.GetButton("P1 LB");
        var up = Input.GetButton("P1 Up");
        var down = Input.GetButton("P1 Down");
        var rT = Input.GetAxis("P1 RT");

        if (hor != 0)
        {
            Debug.Log("P1 Horizontal: " + hor);
            rb.AddRelativeForce(new Vector3(2 * hor, 0, 0)); //todo translate the force
        }

        if (vert != 0)
        {
            Debug.Log("P1 Vertical: " + vert);
            rb.AddRelativeForce(new Vector3(0, 0, 2 * vert));
        }

        if (up)
        {
            Debug.Log("P1 Up");
            rb.AddRelativeForce(new Vector3(0, 2, 0));
        }

        if (down)
        {
            Debug.Log("P1 Down");
            rb.AddRelativeForce(new Vector3(0, -2, 0));
        }

        if (mX != 0)
        {
            Debug.Log("P1 mX: " + mX);
            transform.Rotate(Vector3.up * mX);
        }

        if (mZ != 0)
        {
            Debug.Log("P1 mZ: " + mZ);
            transform.Rotate(Vector3.right * mZ);
        }

        if (rBump)
        {
            Debug.Log("P1 rBump: " + rBump);
            transform.Rotate(Vector3.back);
        }

        if (lBump)
        {
            Debug.Log("P1 lBump: " + rBump);
            transform.Rotate(Vector3.forward);
        }

        // if (rT != 0 || rT != -1)
        // {
        //     Debug.Log("P1 RT: " + rT);
        // }
    }
}
