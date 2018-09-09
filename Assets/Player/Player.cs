using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Player : MonoBehaviour
{

    public string joy;
    public GameObject assualtRifle;
    public GameObject rocketLauncher;
    public GameObject missile;
    public GameObject rocketBarrel;
    [Range(0, 20f)]
    public int hitDistance = 10;
    public int kills = 0;
    public int deaths = 0;
    public int velocity = 4;
    public Text killText;
    private Rigidbody rb;
    private ParticleSystem assualtParticle;
    private ParticleSystem rocketParticle;
    private Animator animator;
    private bool firing;

    // Use this for initialization
    void Start()
    {
        rb = GetComponent<Rigidbody>();
        assualtParticle = assualtRifle.GetComponentInChildren<ParticleSystem>();
        rocketParticle = rocketLauncher.GetComponentInChildren<ParticleSystem>();
        animator = GetComponentInChildren<Animator>();
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
            rb.AddRelativeForce(new Vector3(velocity * hor, 0, 0)); //todo translate the force
        }

        if (vert != 0)
        {
            rb.AddRelativeForce(new Vector3(0, 0, velocity * vert));
        }

        if (up)
        {
            rb.AddRelativeForce(new Vector3(0, velocity, 0));
        }

        if (down)
        {
            rb.AddRelativeForce(new Vector3(0, -velocity, 0));
        }

        if (mX != 0)
        {
            transform.Rotate(Vector3.up * velocity * mX);
        }

        if (mZ != 0)
        {
            transform.Rotate(Vector3.right * velocity * mZ);
        }

        if (rBump)
        {
            transform.Rotate(Vector3.back * velocity);
        }

        if (lBump)
        {
            transform.Rotate(Vector3.forward * velocity);
        }

        if (rT != 0 && rT != -1)
        {
            if (!rocketLauncher.activeSelf)
            {
                // Fire(assualtParticle.transform);
                if (!assualtParticle.isPlaying)
                {
                    assualtParticle.Play(true);
                }
            }
            else
            {
                if (!firing)
                {
                    GameObject newMissile = Instantiate(missile, rocketBarrel.transform.position, rocketBarrel.transform.rotation);
                    var rbM = newMissile.GetComponent<Rigidbody>();
                    var locVel = newMissile.transform.InverseTransformDirection(rbM.velocity);
                    locVel.x = 10;
                    rbM.velocity = newMissile.transform.TransformDirection(locVel);
                    newMissile.transform.GetChild(1).GetComponent<ParticleSystem>().Play();
                    firing = !firing;
                }
            }
        }
        else
        {
            if (assualtParticle.isPlaying)
            {
                assualtParticle.Stop();
            }
        }

        if (switchWeapon && !animator.GetBool("IsSwap"))
        {
            StartCoroutine("swapWeapon");
        }
    }

    void OnParticleCollision(GameObject other)
    {
        var player = other.GetComponentInParent<Player>();
        Health health = GetComponent<Health>();
        if (player.joy != joy && health.HP > 0)
        {
            switch (other.name)
            {
                case "Projectile_PS":
                    if (health.HP - health.bulletHp <= 0)
                    {
                        health.HP = 0;
                        player.kills++;
                        player.killText.text = player.kills.ToString();
                        deaths++;
                        Debug.LogError("DEAD");
                        Debug.LogError(joy + "Deaths: " + deaths);
                        Debug.LogError(joy + "Kills: " + kills);
                        Debug.LogError(player.joy + "Deaths: " + player.deaths);
                        Debug.LogError(player.joy + "Kills: " + player.kills);
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

    private IEnumerator swapWeapon()
    {
        animator.SetBool("IsSwap", true);
        yield return new WaitForSeconds(0.4f);
        var rVal = !rocketLauncher.activeSelf;
        var aVal = !assualtRifle.activeSelf;
        rocketLauncher.SetActive(false);
        assualtRifle.SetActive(false);
        yield return new WaitForSeconds(0.3f);
        animator.SetBool("IsSwap", false);
        yield return new WaitForSeconds(0.5f);
        rocketLauncher.SetActive(rVal);
        assualtRifle.SetActive(aVal);
    }
}
