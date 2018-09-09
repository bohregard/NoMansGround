using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player : MonoBehaviour
{

    public string joy;
    public GameObject assualtRifle;
    public GameObject rocketLauncher;
    [Range(0, 20f)]
    public int hitDistance = 10;
    private Rigidbody rb;
    private ParticleSystem assualtParticle;
    private ParticleSystem rocketParticle;

    // Use this for initialization
    void Start()
    {
        rb = GetComponent<Rigidbody>();
        assualtParticle = assualtRifle.GetComponentInChildren<ParticleSystem>();
        rocketParticle = rocketLauncher.GetComponentInChildren<ParticleSystem>();
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
        var switchWeapon = Input.GetButtonDown(joy + "Weapon");
        // var lT = Input.GetAxis(joy + "LT");
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
            // Fire(assualtParticle.transform);
            if (!assualtParticle.isPlaying)
            {
                assualtParticle.Play(true);
            }

        }
        else
        {
            if (assualtParticle.isPlaying)
            {
                assualtParticle.Stop();
            }
        }

        if (switchWeapon)
        {
            rocketLauncher.SetActive(!rocketLauncher.activeSelf);
            assualtRifle.SetActive(!assualtRifle.activeSelf);
        }
    }

    void OnCollisionEnter(Collision col)
    {
        Debug.Log("Collision " + joy);
    }

    void OnParticleCollision(GameObject other)
    {
        if (other.GetComponentInParent<Player>().joy != joy)
        {
            Health health = GetComponent<Health>();
            switch (other.name)
            {
                case "AssaultParticle":
                    if (health.HP - health.bulletHp <= 0)
                    {
                        health.HP = 0;
                        Debug.LogError("DEAD");
                    }
                    else
                    {
                        health.HP -= health.bulletHp;
                    }
                    break;
                case "RocketParticle":
                    if (health.HP - health.rocketHp <= 0)
                    {
                        health.HP = 0;
                        Debug.LogError("DEAD");
                    }
                    else
                    {
                        health.HP -= health.rocketHp;
                    }
                    break;
            }
        }
    }

    private void Fire(Transform t)
    {
        RaycastHit hit;
        if (Physics.Raycast(t.position, t.TransformDirection(Vector3.forward), out hit, hitDistance, LayerMask.GetMask("Players")))
        {
            Debug.DrawRay(t.position, t.TransformDirection(Vector3.forward) * hit.distance, Color.yellow);
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
            Debug.DrawRay(t.position, t.TransformDirection(Vector3.forward) * hitDistance, Color.white);
        }
    }
}
